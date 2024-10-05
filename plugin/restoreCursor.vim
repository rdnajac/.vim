augroup RestoreCursor
  autocmd!
  autocmd BufReadPost *
	\ let line = line("'\"")
	\ | if line >= 1 && line <= line("$")
	\ |   execute "normal! g`\""
	\ |   execute "silent! normal! zO"
	\ | endif
augroup END
