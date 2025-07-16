function! sesh#restore() abort
  " let sesh = fnameescape(getcwd() . '/Session.vim')
  " let sesh = stdpath('data') . '/Session.vim'
  let sesh = fnameescape(g:VIMHOME . '/Session.vim')
  if filereadable(sesh)
    execute 'silent! source ' . sesh
    " call delete(sesh)
    Obsession!
    "   " HACK rounded border fix for snacks dashboard
    "   if argc() == 0 && has('nvim')
    "     set winborder=rounded
    "     " doautocmd User SnacksDashboardOpened
    "   endif
  endif
endfunction
