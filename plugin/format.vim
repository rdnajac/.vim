function! s:err_undo() abort
  if v:shell_error > 0
    silent undo
    redraw
    echomsg 'formatprg "' . &formatprg . '" exited with status ' . v:shell_error
  endif
endfunction

function! GQ(type, ...)
  if !empty(&formatprg)
    normal! '[v']gq
    call s:err_undo()
  else
    normal! '[v']=
    call format#clean_whitespace()
  endif
  call winrestview(w:gqview)
  unlet w:gqview
endfunction
nnoremap <silent> gq :<C-U>let w:gqview = winsaveview()<CR>:set opfunc=GQ<CR>g@

function! Format() abort
  " normal gqag
  keepjumps normal gqag
endfunction
" set formatexpr=<SID>format()

function! s:format_if_modified() abort
  if &modified
    call Format()
  endif
endfunction

augroup AutoFormat
  autocmd!
  autocmd BufWritePre *.lua call <SID>format_if_modified()
  autocmd BufWritePre *.vim call <SID>format_if_modified()
  autocmd BufWritePre *.sh  call <SID>format_if_modified()
  autocmd BufWritePre *.md  call <SID>format_if_modified()
augroup END
