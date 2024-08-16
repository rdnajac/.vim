" after/plugin/ale.vim
let g:ale_disable_lsp	      = 1
let g:ale_completion_enabled  = 0
let g:ale_linters_explicit    = 1
let g:ale_linters = { 
      \ 'sh'      : ['shellcheck', 'cspell', ], 
      \ 'markdown': ['markdownlint', 'marksman', 'cspell'], 
      \ 'python'  : ['ruff'], 
      \ 'vim'     : ['vint'], 
      \ }

" ignore md013 line length
let g:ale_markdown_markdownlint_options = '--disable MD013'

let g:ale_fixers = { 
      \ 'markdown': ['remove_trailing_lines', 'trim_whitespace', 'prettier'], 
      \ 'sh'      : ['remove_trailing_lines', 'trim_whitespace'], 
      \ }

hi clear ALEErrorSign
hi clear ALEWarningSign
let g:ale_sign_error = '💩'
let g:ale_sign_warning = '🔥'
" hide sign column
" set signcolumn=no
" let g:ale_virtualtext_prefix = '%comment% %type%: '
 " let g:ale_virtualtext_prefix = '💩 '
" let g:ale_virtualtext_prefix = ''
let g:ale_virtualtext_cursor = 'current'
let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰', '│', '─']

nnoremap <leader>ai :ALEInfo<CR>
nnoremap <leader>af :ALEFix<CR>
nnoremap <leader>al :ALELint<CR>
nnoremap <leader>an :ALENext<CR>
nnoremap <leader>ap :ALEPrevious<CR>
nnoremap <leader>aq :ALEDetail<CR>
nnoremap <leader>ad :ALEGoToDefinition<CR>
nnoremap <leader>ar :ALEFindReferences<CR> 
" ☁️
