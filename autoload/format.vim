function format#plus_to_backticks() abort
  %s/^+++$/```/ge
endfunction

function format#normalize_quotes() abort
  %s/[“”]/"/ge
endfunction

function s:strip_trailing_whitespace() abort
  %s/\s\+$//e
endfunction

function s:strip_trailing_newlines() abort
  %s/\n\+\%$//e
endfunction

function! format#clean_whitespace() abort
  let l:size = line2byte(line('$') + 1) - 1
  call s:strip_trailing_whitespace()
  call s:strip_trailing_newlines()
  let l:final_size = line2byte(line('$') + 1) - 1

  if l:final_size != l:size
    echomsg 'Stripped ' . (l:size - l:final_size) . ' bytes of trailing whitespace'
  endif
endfunction

function! s:equalprg() abort
  normal! gg=G
  retab
  if !&binary && &filetype != 'diff'
    " TODO: check for g: and b: variables
    call s:strip_trailing_whitespace()
    call s:strip_trailing_newlines()
  endif
endfunction

function! format#expr() abort
  let l:start = v:lnum
  let l:end = v:lnum + v:count - 1
  let l:lines = getline(l:start, l:end)

  if empty(&formatprg)
    call s:equalprg()
    return 0
  else
    echom 'Using formatprg: ' . &formatprg
  endif

  " Run formatprg on those lines via stdin
  let l:cmd = expandcmd(&formatprg)
  let l:output = systemlist(l:cmd, l:lines)

  if v:shell_error || empty(l:output)
    echohl WarningMsg |
    echom 'Formatter failed or returned nothing'
    echohl None
    return v:shell_error ? v:shell_error : 1
  elseif l:output !=# l:lines
    let l:view = winsaveview()
    execute l:start . ',' . l:end . 'delete _'
    undojoin | call append(l:start - 1, l:output)
    call winrestview(l:view)
  endif

  return 0
endfunction

function! format#buffer() abort
  let l:view = winsaveview()

  try
    if empty(&formatprg)
      call s:equalprg()
    else
      normal gggqG
      " keepjumps normal! gggqG
      " BUG: someitmes a newline is added
      call s:strip_trailing_newlines()
    endif
  catch /^Vim\%((\a\+)\)\=:E/
    echohl ErrorMsg | echom 'Formatting failed: ' . v:exception | echohl None
  finally
    call winrestview(l:view)
  endtry
endfunction
