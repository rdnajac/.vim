" sessions, restarts, and more
" Saving options in session and view files causes more problems than it
" solves, so disable it.

" default in nvim
set sessionoptions-=options
" from vim-obsession
set sessionoptions-=blank
set sessionoptions+=tabpages
" from defaults.vim
set viewoptions-=options

if !has('nvim')
  finish
endif

function! s:restart() abort
  let sesh = fnameescape(stdpath('state') . '/Session.vim')
  execute 'mksession! ' . sesh
  let cmd = 'silent! source ' . sesh
  execute 'restart ' cmd
endfunction

command! Restart call s:restart()
