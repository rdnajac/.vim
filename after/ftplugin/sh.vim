" after/ftplugin/sh.vim
setlocal wrap
setlocal iskeyword+=.

" snippets
" inoremap <buffer> () ()<Space>{<CR>}<Esc>O
" inoremap <buffer> if if ; then<CR><CR>fi<CR><Up><Up><Esc>O
" iab ,if if ; then<CR><CR>fi<Up><Up><Right>[<Space>]<Left><Left>
" iab ,for for ; do<CR><CR>done<Up><Up><Esc>O
" inoreab ,ffor ; do<CR><CR>done<Up><Up><Esc>Ifor f in ./

" set includeexpr to expand env vars in includes
" let &l:includeexpr = "substitute(v:fname, '$\\%(::\\)\\=env(\\([^)]*\\))', '\\=expand(\"$\".submatch(1))', 'g')"
