if has('nvim')
  let g:ale_disable_lsp = 1
  let g:ale_use_neovim_diagnostics_api = 1
endif

let g:ale_fixers = {
      \   '*': ['remove_trailing_lines', 'trim_whitespace'],
      \}


let g:ale_linters_explicit = 1
let g:ale_fix_on_save = 0
let g:ale_completion_enabled = 0
" let g:ale_linters_explicit = 1
let g:ale_virtualtext_cursor = '0'
let g:ale_lint_on_text_changed = 'never'
let g:ale_echo_cursor = 'never'

nmap <leader>af <Cmd>ALEFix<CR>
nmap <leader>ai <Cmd>ALEInfo<CR>
nmap <leader>al <Cmd>ALELint<CR>
