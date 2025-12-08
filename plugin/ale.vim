scriptencoding utf-8

let g:ale_virtualtext_cursor = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_echo_cursor = 'never'
" move fixers to ftplugin if we use `vim.lsp` for formatting
let g:ale_fixers = {
      \ '*'	  : ['remove_trailing_lines', 'trim_whitespace'],
      \ 'python'  : ['ruff'],
      \ 'sh'	  : ['shfmt','shellharden'],
      \ 'r'	  : ['styler'],
      \ }

let g:ale_linters = {
      \ 'lua' : ['lua_language_server'],
      \ 'vim' : ['vint'],
      \ }

if has('nvim')
  let g:ale_completion_enabled = 0
  let g:ale_disable_lsp = 1
  let g:ale_use_neovim_diagnostics_api = 1
else
  hi clear ALEErrorSign
  hi clear ALEWarningSign
  let g:ale_sign_error   = '🔥'
  let g:ale_sign_warning = '💩'
  let g:ale_floating_window_border =
	\ ['│', '─', '╭', '╮', '╯', '╰', '│', '─']
endif

nnoremap <leader>aD <Cmd>ALEGoToDefinition<CR>
nnoremap <leader>aF <Cmd>ALEFix<CR>
nnoremap <leader>aI <Cmd>ALEInfo<CR>
nnoremap <leader>al <Cmd>ALELint<CR>
nnoremap <leader>an <Cmd>ALENext<CR>
nnoremap <leader>ap <Cmd>ALEPrevious<CR>
nnoremap <leader>aq <Cmd>ALEDetail<CR>
nnoremap <leader>ar <Cmd>ALEFindReferences<CR>


augroup myalesettings
  au BufRead,BufNewFile */.github/*/*.y{,a}ml let b:ale_linters = {'yaml': ['actionlint']}
augroup END
