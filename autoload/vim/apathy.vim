function! vim#apathy#(...) abort
  let orig = getbufvar('', '&path')
  let new = list#join(list#uniq(call('list#split', a:000 + [orig])))
  " let new = list#prepend(orig, a:000)
  call setbufvar('', '&path', new)
  return new
endfunction
