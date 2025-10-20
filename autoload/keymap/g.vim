function! keymap#g#f() abort
  let uri = expand('<cWORD>')
  if uri =~# ':\d\+$'
    return 'gF'
  else
    return 'gf'
  endif
endfunction

" nnoremap <silent> gq :<C-U>let w:gqview=winsaveview()<CR>:set opfunc=keymap#opfunc#format<CR>g@
" function! keymap#g#q() abort

