" after/plugin/config.vim

" NetrwBrowseX
xunmap gx
nunmap gx

" no Ex mode
nnoremap Q <nop>

let s:dotfiles           = '\(^\|\s\s\)\zs\.\S\+'
let g:netrw_list_hide    = netrw_gitignore#Hide() . ',' . s:dotfiles
let g:netrw_liststyle    = 3
let g:netrw_winsize      = 20
let g:netrw_browse_split = 3
let g:netrw_altv         = 1  " open splits to the right
let g:netrw_banner       = 0  " hide banner

let g:copilot_workspace_folders = ["~/.vim", "~/.files", "~/cbmf"]

let g:ale_disable_lsp = 1
let g:ale_completion_enabled = 0
let g:ale_linters_explicit = 1
let g:ale_linters = { 'sh': ['shellcheck'], 'markdown': ['markdownlint', 'marksman'], 'python': ['ruff'], 'vim': ['vint'], }
let g:ale_fixers_explicit = 1
let g:ale_fixers = { 'markdown': ['prettier', 'remove_trailing_lines', 'trim_whitespace'], 'sh': ['shfmt', 'shellharden', 'remove_trailing_lines', 'trim_whitespace'], }
" TODO fix this
" ALE interface {{{
hi clear ALEErrorSign
hi clear ALEWarningSign
let g:ale_sign_error = '💩'
let g:ale_sign_warning = '💩'
" let g:ale_echo_msg_error_str = '💩'
let g:ale_echo_msg_warning_str = '👾'
let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰', '│', '─']
 
