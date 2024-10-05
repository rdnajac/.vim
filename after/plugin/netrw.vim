" after/plugin/netrw.vim

" open netrw in a vertical split
nnoremap <silent> <leader>e :Lexplore<CR>

let s:dotfiles           = '\(\|\s\s\)\zs\.\S\+'
let g:netrw_list_hide    = s:dotfiles
let g:netrw_list_hide   += netrw_gitignore#Hide()
let g:netrw_winsize      = 20 
let g:netrw_banner       = 0  " suppress the banner
let g:netrw_liststyle    = 3  " tree style listing
let g:netrw_browse_split = 3  " open file in new tab
let g:netrw_altv         = 1  " change from left splitting to right splitting

augroup netrw_autocmds
  autocmd!
  autocmd BufLeave netrw call netrw#NetrwQuit()  " close window when we leave the buffer
  autocmd FileType netrw nmap <buffer> <Tab> :bd<CR>
  autocmd VimLeave * 
	\ if filereadable(expand(expand('~/.vim/.netrwhist'))) 
	\ | call delete(expand('~/.vim/.netrwhist')) 
	\ | endif
augroup END

" unmap NetrwBrowseX because I keep fat fingering it
xunmap gx
nunmap gx
