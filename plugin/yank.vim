" see `:h yankring`
augroup yankring
  autocmd!
  autocmd TextYankPost * if v:event.operator ==# 'y' |
	\ for i in range(9, 1, -1) |
	\   call setreg(string(i), getreg(string(i - 1))) |
	\ endfor |
	\ endif
augroup END

if !has('nvim')
  packadd hlyank
else
  augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua vim.hl.on_yank()
  augroup END
endif
