augroup lsp_template
  autocmd!
  autocmd BufReadPost *.template execute 'set filetype=' . fnamemodify(expand('<afile>'), ':p:t:r:e')
  autocmd BufNewFile after/lsp/*.lua
	\ if filereadable(stdpath('config') . '/templates/lsp.lua.template') |
	\   execute '0r '.stdpath('config') . '/templates/lsp.lua.template'  |
	\ endif
augroup END
