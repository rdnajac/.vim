function s:strip_trailing_whitespace() abort
  %s/\s\+$//e
endfunction

function s:strip_trailing_newlines() abort
  %s/\n\+\%$//e
endfunction

function format#plus_to_backticks() abort
  %s/^+++$/```/ge
endfunction

function format#normalize_quotes() abort
  %s/[“”]/"/ge
endfunction

function! format#whitespace() abort
  let l:size = line2byte(line('$') + 1) - 1
  call s:strip_trailing_whitespace()
  call s:strip_trailing_newlines()
  let l:final_size = line2byte(line('$') + 1) - 1

  if l:final_size != l:size
    echomsg 'Stripped ' . (l:size - l:final_size) . ' bytes of trailing whitespace'
  endif
endfunction

function! format#buffer() abort
  let l:winview = winsaveview()
  let l:formatter = !empty(&formatexpr) ? &formatexpr : &formatprg
  write

  try
    if empty(l:formatter) || &ft == 'vim'
      echomsg 'Running indent, retab, and cleanup...'
      normal! gg=G
      retab
      if !&binary && &filetype != 'diff'
	call format#whitespace()
      endif
    else
      normal! gggqG
      if v:shell_error > 0
	silent undo
	redraw
	throw 'Formatter exited with status ' . v:shell_error
      endif
    endif
    write
    " echom 'Buffer formatted with "' . l:formatter . '" and saved!'
  catch
    echohl ErrorMsg
    echomsg 'Error: ' . v:exception
    echohl None
    return
  finally
    call winrestview(l:winview)
  endtry
endfunction
