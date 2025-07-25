" sessions, restarts, and more
if !has('nvim')
  finish
endif

function! s:restart() abort
  " TODO: set up obsession natively
  if exists(':Obsession')
    execute 'Obsession ' . stdpath('state')
  endif
  restart
endfunction

function! s:restore() abort
  " TODO: make it work for local sessions too
  " let sesh = fnameescape(getcwd() . '/Session.vim')
  let sesh = stdpath('state') . '/Session.vim'
  if filereadable(sesh)
    execute 'silent! source ' . sesh
    " call delete(sesh)
    Obsession!
  endif
endfunction

command! Restart call s:restart()

augroup sesh
  au!
  au VimEnter * nested call s:restore()
augroup END
