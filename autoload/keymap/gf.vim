function! keymap#gf#() abort
  let uri = expand('<cWORD>')
  if uri =~# ':\d\+$'
    return 'gF'
  else
    return 'gf'
  endif
endfunction
