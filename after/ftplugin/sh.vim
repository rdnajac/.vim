" after/ftplugin/sh.vim
setlocal cindent shiftwidth=8 softtabstop=8 noexpandtab
setlocal iskeyword+=.
compiler shellcheck
nnoremap <localleader>b i#!/bin/bash<CR>#<CR>#<space>

" set includeexpr to expand env vars in includes
" let &l:includeexpr = "substitute(v:fname, '$\\%(::\\)\\=env(\\([^)]*\\))', '\\=expand(\"$\".submatch(1))', 'g')"

