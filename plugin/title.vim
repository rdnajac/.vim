function! s:fname() abort
  let l:gitdir = git#root()
  let l:fname = expand('%')
  let l:relpath = substitute(l:fname, l:gitdir, '', '')
  let l:relpath = substitute(l:relpath, '^\/*', '', '')
  let l:relpath = substitute(l:relpath, '^\s\+', '', '')
  return l:relpath
endfunction

function! FileTitle() abort
  execute append(0, s:fname())
  normal gcc
endfunction

" <leader>fn: insert the output of Fname() at the top of the file, then comment it
nnoremap <silent> <leader>fn <Cmd>call FileTitle()<CR>
