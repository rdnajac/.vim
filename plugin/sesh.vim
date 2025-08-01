" sessions, restarts, and more
if !has('nvim')
  finish
endif

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

function! s:restart() abort
  if exists(':Obsession')
    execute 'Obsession ' . stdpath('state')
  endif
  " " let sesh = fnameescape(stdpath('state') . '/Session.vim')
  " restart echo "Hello"\013
  confirm restart
endfunction

" TODO: once this is merged,
" https://github.com/neovim/neovim/pull/35045
" add argsQ

command! Restart call s:restart()

augroup sesh
  au!
  au VimEnter * nested call s:restore()
augroup END
