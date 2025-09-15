function! vim#close#float() abort
  if !has('nvim')
    execute 'normal! q'
  elseif luaeval("Snacks.util.is_float()")
    echom 'is float, quitting'
    quit
  endif
endfunction
