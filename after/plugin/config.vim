" after/plugin/config.vim
augroup vimrc_netrw
  autocmd!
  autocmd BufLeave netrw call netrw#NetrwQuit()  " close window when we leave the buffer
  autocmd VimLeave * 
	\ if filereadable(expand(expand('~/.vim/.netrwhist'))) 
	\ | call delete(expand('~/.vim/.netrwhist')) 
	\ | endif
augroup END
nnoremap <silent> <leader>` :Lexplore<CR>
" unmap NetrwBrowseX because I keep fat fingering it
xunmap gx
nunmap gx

let s:dotfiles           = '\(^\|\s\s\)\zs\.\S\+'

let g:netrw_list_hide    = netrw_gitignore#Hide() . ',' . s:dotfiles
let g:netrw_winsize      = 20 
let g:netrw_banner       = 0  " suppress the banner
let g:netrw_liststyle    = 3  " tree style listing
let g:netrw_browse_split = 3  " open file in new tab
let g:netrw_altv         = 1  " change from left splitting to right splitting

let g:copilot_workspace_folders = ["~/.vim", "~/.files", "~/cbmf"]
 
