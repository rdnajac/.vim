function! git#root(...) abort
  let l:file = a:0 ? a:1 : expand('%:p')
  let l:gitdir = finddir('.git', l:file . ';')
  if empty(l:gitdir)
    return ''
  endif
  let l:root = fnamemodify(l:gitdir, ':p:h:h')
  return l:root
endfunction

function! git#url(user_repo) abort
  return 'http://github.com/' . a:user_repo . '.git'
endfunction
