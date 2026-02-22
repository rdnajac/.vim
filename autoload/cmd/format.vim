function! cmd#format#() abort
  if exists(':ALEFix') == 2 && exists('g:ale_fixers') && has_key(g:ale_fixers, &ft)
    ALEFix
    return
  endif
  call vim#with#savedView('call format#buffer()')
endfunction
