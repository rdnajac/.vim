function! daa#delete_argument() abort
  " Try: delete arg and trailing ", "
  if search(',\s*', 'W', line('.')) > 0
    normal! dv,l
  else
    " Last arg: delete back to the ", "
    normal! F,dw
  endif
endfunction
