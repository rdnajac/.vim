function! s:fname() abort
  let l:gitdir = git#root()
  let l:fname = fnamemodify(expand('%'), ':p')
  let l:relpath = substitute(l:fname, l:gitdir, '', '')
  let l:relpath = substitute(l:relpath, '^\/*', '', '')
  let l:relpath = substitute(l:relpath, '^\s\+', '', '')
  return l:relpath
endfunction

function! file#title() abort
  execute append(0, s:fname())
  " vint: -ProhibitCommandRelyOnUser
  normal gcc
  " vint: +ProhibitCommandRelyOnUser
endfunction

function! file#rename() abort
  if has('nvim')
    lua Snacks.rename.renme_file()
  elseif exists(':Rename')
    Rename
  else
    Warn 'No rename command available'
  endif
endfunction
