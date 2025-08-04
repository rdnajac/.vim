" sessions, restarts, and more
if !has('nvim')
  finish
endif

" TODO: make it work for local sessions too
function! s:restart() abort
  if exists(':Obsession')
    execute 'Obsession ' . stdpath('state')
  endif
  restart execute 'silent! source ' . stdpath('state') . '/Session.vim | Obsession!'
endfunction

command! Restart call s:restart()
