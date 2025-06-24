function! print#msg(...) abort
  let l:args = copy(a:000)
  let l:msg = join(map(l:args, 'string(v:val)'), ' ')
  " if has('nvim')
  "   call v:lua.dd(l:msg)
  " else
  echomsg l:msg
  " endif
endfunction
