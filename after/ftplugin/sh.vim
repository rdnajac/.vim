" after/ftplugin/sh.vim
setlocal iskeyword+=.
nnoremap <localleader>b i#!/bin/bash<CR>#<CR>#<space>

" set includeexpr to expand env vars in includes
" let &l:includeexpr = "substitute(v:fname, '$\\%(::\\)\\=env(\\([^)]*\\))', '\\=expand(\"$\".submatch(1))', 'g')"

