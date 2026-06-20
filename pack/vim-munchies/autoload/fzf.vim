function! fzf#complete(...)
  return call('fzf#vim#complete', a:000)
endfunction
