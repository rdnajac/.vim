function! register#clear_all() abort
  " for r in split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', '\zs')
  call map(
	\ range(char2nr('a'), char2nr('z')) +
	\ range(char2nr('A'), char2nr('Z')) +
	\ range(char2nr('0'), char2nr('9')),
	\ {_, r -> setreg(nr2char(r), '')})
endfunction

function! register#yankring() abort
  if v:event.operator ==# 'y'
    " call map(range(9, 1, -1), {_, i -> setreg(string(i), getreg(string(i-1)))})
    for i in range(9, 1, -1)
      call setreg(string(i), getreg(string(i - 1)))
    endfor
  endif
endfunction

function! register#set_clipboard() abort
  if !has('nvim')
    set clipboard=unnamed
  elseif !exists('$SSH_TTY')
    " don't set clipboard over ssh
    set clipboard=unnamedplus
  endif
endfunction

function! register#clipboard_fallback() abort
  if empty(&clipboard)
    " map default yank to system clipboard
    nnoremap <expr> y v:register == '"' ? '"+y' : 'y'
    vnoremap <expr> y v:register == '"' ? '"+y' : 'y'
    " copy the last yanked text to the system clipboard
    silent let @+ = getreg('"')
  endif
endfunction
