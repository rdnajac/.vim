augroup lsp_template
  autocmd!
  autocmd BufNewFile after/lsp/*.lua
	\ if filereadable(stdpath('config') .. '/templates/lsp.lua') |
	\   execute '0r ' .. stdpath('config') .. '/templates/lsp.lua' |
	\ endif
augroup END
