" Set quickfix method based on whether `pplatex` is executable
let g:vimtex_quickfix_method = executable('pplatex') ? 'pplatex' : 'latexlog'

" Disable vimtex mapping for `K` in normal mode
let g:vimtex_mappings_disable = {'n': ['K']}

" Correctly setup lspconfig for LaTeX
nmap <leader>K <Plug>(vimtex-doc-package)
