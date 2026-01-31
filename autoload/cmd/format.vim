function! cmd#format#() abort
  if exists(':ALEFix') == 2 && exists('g:ale_fixers') && has_key(g:ale_fixers, &ft)
    ALEFix
    return
  endif
  call execute#inPlace('call format#buffer()')
endfunction
