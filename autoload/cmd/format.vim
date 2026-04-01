function! cmd#format#() abort
  if exists(':ALEFix') == 2 && exists('g:ale_fixers') && has_key(g:ale_fixers, &ft)
    Info '`ALEFix()`ing...'
    ALEFix
    return
  endif
  " format
  call endfunction
