" function! s:err_undo() abort
"   if v:shell_error > 0
"     silent undo
"     redraw
"     echomsg 'formatprg "' . &formatprg . '" exited with status ' . v:shell_error
"   endif
" endfunction

function! Format() abort
  let l:cmd = 'normal! gg' . (empty(&formatprg) ? '=' : 'gq') . 'G'
  call format#wrap(l:cmd)
endfunction

function! s:format_if_modified() abort
  if &modified
    call Format()
  endif
endfunction

" BUG: undo tree is not restored properly after formatting
" BUG: undo should not change position
" BUG: sometimes undo tree is completely lost
augroup AutoFormat
  autocmd!
  "   autocmd BufWritePre *.lua call <SID>format_if_modified()
  autocmd BufWritePre *.vim call execute#inPlace('normal! gg=G')
  "   autocmd BufWritePre *.sh  call <SID>format_if_modified()
  "   autocmd BufWritePre *.md  call <SID>format_if_modified()
augroup END
