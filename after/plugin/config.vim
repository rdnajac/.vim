" after/plugin/config.vim
" unmap shortcut to NetrwBrowseX
xunmap gx
nunmap gx


" }}}
let g:copilot_workspace_folders = ["~/.vim", "~/.files", "~/cbmf"]
" let g:copilot_no_tab_map = v:true
" imap <silent><script><expr> <C-@> copilot#Accept("")

" let g:ale_disable_lsp = 1
let g:ale_completion_enabled = 0
"set omnifunc=ale#completion#OmniFunc
let g:ale_linters_explicit = 1
let g:ale_linters = { 'markdown': ['markdownlint', 'marksman'], 'python': ['ruff'], 'vim': ['vint'], }
let g:ale_fixers_explicit = 1
let g:ale_fixers = { 'markdown': ['prettier', 'remove_trailing_lines', 'trim_whitespace'] }
hi clear ALEErrorSign
hi clear ALEWarningSign
let g:ale_sign_error = '💩'
let g:ale_sign_warning = '💩'
