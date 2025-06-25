if has('nvim')
  let g:ale_disable_lsp = 1
  let g:ale_use_neovim_diagnostics_api = 1
endif


" ALE globals {{{3
let g:ale_fixers = {
      \   '*': ['remove_trailing_lines', 'trim_whitespace'],
      \}
let g:ale_fix_on_save = 0
let g:ale_completion_enabled = 0
let g:ale_linters_explicit = 1
let g:ale_virtualtext_cursor = 'current'
" let g:ale_set_highlights = 0
