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
 
