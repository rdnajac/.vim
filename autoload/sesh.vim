function! sesh#restore() abort
" let sesh = fnameescape(getcwd() . '/Session.vim')
let sesh = fnameescape(g:VIMDIR . '/Session.vim')
  if filereadable(sesh)
    " && argc() == 0
    execute 'silent! source ' . sesh
    " call delete(sesh)
    Obsession!
  endif
endfunction
