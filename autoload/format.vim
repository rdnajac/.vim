function format#plus_to_backticks() abort
  %s/^+++$/```/ge
endfunction

function format#normalize_quotes() abort
  %s/[“”]/"/ge
endfunction

function format#delete_blank_lines() abort
  g/^$/d
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

function! format#equalprg() abort
  normal! gg=G
  retab
  if !&binary && &filetype != 'diff'
    " TODO: check for g: and b: variables
    call s:strip_trailing_whitespace()
    call s:strip_trailing_newlines()
  endif
endfunction
