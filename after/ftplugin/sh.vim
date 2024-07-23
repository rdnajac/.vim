" after/ftplugin/sh.vim
setlocal iskeyword+=.
nnoremap <localleader>b i#!/bin/bash<CR>#<CR>#<space>

" set includeexpr to expand env vars in includes
" let &l:includeexpr = "substitute(v:fname, '$\\%(::\\)\\=env(\\([^)]*\\))', '\\=expand(\"$\".submatch(1))', 'g')"

" Go language server
" if !g:loaded_lsp = true
if ! (get(g:, 'loaded_lsp', 0))
  finish
endif
echo "Loading Go language server"

call LspAddServer([#{
	\    name: 'bashls',
	\    filetype: ['sh'],
	\    path: '/lib/node_modules/bash-language-server/out/cli.js',
	\    args: [''],
	\  }])


