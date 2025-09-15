" yank/delete everything
nnoremap yY <Cmd>%y<CR>
nnoremap dD <Cmd>%d<CR>

" delete/paste without yanking
nnoremap dy "_dd
vnoremap <leader>d "_d
vnoremap <leader>p "_dP

" yank path
nnoremap yp <Cmd>let @*=expand('%:p:~')<CR>

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
