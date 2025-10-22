function! register#clear() abort
  for r in split('abcdefghijklmnopqrstuvwxyz0123456789', '\zs')
    call setreg(r, '')
  endfor
endfunction
