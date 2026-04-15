function! register#clear_all() abort
  " for r in split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', '\zs')
  call map(
	\ range(char2nr('a'), char2nr('z')) +
	\ range(char2nr('A'), char2nr('Z')) +
	\ range(char2nr('0'), char2nr('9')),
	\ {_, r -> setreg(nr2char(r), '')})
endfunction
