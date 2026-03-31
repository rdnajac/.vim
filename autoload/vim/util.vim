function! vim#util#clear_registers() abort
  " for r in split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', '\zs')
  for r in map(
	\ range(char2nr('a'), char2nr('z')) +
	\ range(char2nr('A'), char2nr('Z')) +
	\ range(char2nr('0'), char2nr('9')),
	\ 'nr2char(v:val)')
    call setreg(r, '')
  endfor
endfunction
