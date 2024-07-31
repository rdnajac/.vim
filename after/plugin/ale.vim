" after/plugin/ale.vim
let g:ale_disable_lsp = 1
let g:ale_completion_enabled = 0
let g:ale_linters_explicit = 1
let g:ale_linters = { 
      \ 'sh'      : ['shellcheck'], 
      \ 'markdown': ['markdownlint', 'marksman'], 
      \ 'python'  : ['ruff'], 
      \ 'vim'     : ['vint'], 
      \ }

" let g:ale_fixers_explicit = 1
let g:ale_fixers = { 
      \ 'markdown': ['remove_trailing_lines', 'trim_whitespace', 'prettier'], 
      \ 'sh'      : ['remove_trailing_lines', 'trim_whitespace'], 
      \ }

hi clear ALEErrorSign
hi clear ALEWarningSign
let g:ale_sign_error = '💩'
let g:ale_sign_warning = '💩'
" let g:ale_echo_msg_error_str = '💩'
" let g:ale_echo_msg_warning_str = '👾'
let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰', '│', '─']
" ALE keymaps {{{
"
nnoremap <leader>ai :ALEInfo<CR>
nnoremap <leader>af :ALEFix<CR>
nnoremap <leader>al :ALELint<CR>
nnoremap <leader>an :ALENext<CR>
nnoremap <leader>ap :ALEPrevious<CR>
nnoremap <leader>aq :ALEDetail<CR>
nnoremap <leader>ad :ALEGoToDefinition<CR>
nnoremap <leader>ar :ALEFindReferences<CR> 
