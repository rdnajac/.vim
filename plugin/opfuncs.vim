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
" nnoremap <silent> gq :<C-U>let w:gqview=winsaveview()<CR>:set opfunc=GQ<CR>g@
