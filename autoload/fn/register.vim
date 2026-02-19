function! fn#clear_registers() abort
  for r in split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', '\zs')
    call setreg(r, '')
  endfor
endfunction
