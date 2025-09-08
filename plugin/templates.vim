augroup lsp_template
  autocmd!
  autocmd BufNewFile after/lsp/*.lua
	\ if filereadable(stdpath('config') .. '/templates/lsp.lua.template') |
	\   execute '0r ' .. stdpath('config') .. '/templates/lsp.lu.templatea' |
	\ endif
augroup END
