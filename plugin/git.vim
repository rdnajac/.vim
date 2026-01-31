nnoremap gb vi'"zy:!open https://github.com/<C-R>z<CR>
xnoremap gb    "zy:!open https://github.com/<C-R>z<CR>

nnoremap <leader>gN <Cmd>execute '!open' git#repo('neovim/neovim')<CR>
nnoremap <leader>gZ <Cmd>execute '!open' git#repo('lazyvim/lazyvim')<CR>

" nnoremap <leader>ga <Cmd>!git add %<CR>
" TODO: if `fugitive`
nnoremap <leader>ga <Cmd>Gwrite<CR>
nnoremap gcd :Gcd<Bar>pwd<CR>
