" after/plugin/config.vim
" unmap shortcut to NetrwBrowseX
xunmap gx
nunmap gx
let g:netrw_liststyle =  3
let g:netrw_winsize = 25
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_banner = 0
" let g:netrw_sort_sequence = '[\/]$,*' . (empty(a:suffixes) ? '' : ',\%(' . join(map(split(a:suffixes, ','), 'escape(v:val, ".*$~")'), '\|') . '\)[*@]\=$')

let s:dotfiles = '\(^\|\s\s\)\zs\.\S\+'
let g:netrw_list_hide = netrw_gitignore#Hide() . ',' . s:dotfiles

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
