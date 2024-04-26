setlocal autoindent smartindent
setlocal smarttab expandtab tabstop=4 shiftwidth=4 softtabstop=4
setlocal foldmethod=indent foldlevel=9
packadd black
silent! unmap <leader>w
nnoremap <leader>w :Black<CR>:w<CR>
