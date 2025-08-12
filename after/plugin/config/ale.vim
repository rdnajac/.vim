scriptencoding utf-8

if !exists('g:loaded_ale')
  finish
endif

let g:ale_virtualtext_cursor = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_echo_cursor = 'never'
let g:ale_linters_explicit = 1
" let g:ale_linters = {
  "       \ 'sh'	  : ['shellcheck', 'cspell'],
  "       \ 'markdown': ['markdownlint', 'cspell'],
  "       \ 'python'  : ['ruff'],
  "       \ 'vim'	  : ['vint'],
  "       \ }

  " let g:ale_fix_on_save = 1
  let g:ale_fixers = {
	\ '*'	  : ['remove_trailing_lines', 'trim_whitespace'],
	\ 'markdown': ['prettier'],
	\ 'python'  : ['ruff_format'],
	\ 'sh'	  : ['shfmt','shellharden'],
	\ }

  if has('nvim')
    let g:ale_completion_enabled = 0
    let g:ale_disable_lsp = 1
    let g:ale_use_neovim_diagnostics_api = 1
  else
    let g:ale_floating_window_border =
	  \ ['│', '─', '╭', '╮', '╯', '╰', '│', '─']
    let g:ale_sign_error   = '🔥'
    let g:ale_sign_warning = '💩'
    hi clear ALEErrorSign
    hi clear ALEWarningSign
  endif

  nnoremap <leader>ai <Cmd>ALEInfo<CR>
  nnoremap <leader>af <Cmd>ALEFix<CR>
  nnoremap <leader>al <Cmd>ALELint<CR>
  nnoremap <leader>an <Cmd>ALENext<CR>
  nnoremap <leader>ap <Cmd>ALEPrevious<CR>
  nnoremap <leader>aq <Cmd>ALEDetail<CR>
  nnoremap <leader>ad <Cmd>ALEGoToDefinition<CR>
  nnoremap <leader>ar <Cmd>ALEFindReferences<CR>
