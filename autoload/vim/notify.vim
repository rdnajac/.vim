function vim#notify#error(msg) abort
  if has('nvim')
    call v:lua.Snacks.notify.error(a:msg)
  else
    echohl ErrorMsg
    echom a:msg
    echohl None
  endif
endfunction
