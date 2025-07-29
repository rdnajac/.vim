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
  normal gcc
endfunction
