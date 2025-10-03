" after/plugin/netrw.vim
if has('nvim') | finish | endif

nnoremap <silent> <leader>e :Lexplore<CR>

"let s:dotfiles           = '\(\|\s\s\)\zs\.\S\+'
"let g:netrw_list_hide    = s:dotfiles
"let g:netrw_list_hide   += netrw_gitignore#Hide()
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'
let g:netrw_winsize      = 20
let g:netrw_banner       = 0  " suppress the banner
let g:netrw_browse_split = 3  " open file in new tab
let g:netrw_altv         = 1  " change from left splitting to right splitting
let g:netrw_auto_cd = 1

augroup netrw_autocmds
  autocmd!
  autocmd BufLeave netrw call netrw#NetrwQuit()
  autocmd FileType netrw nmap <buffer> <Tab> :bd<CR>
augroup END

" Automatically delete .netrwhist and .DS_Store files on Vim exit
augroup autoDelete
  autocmd!
  autocmd VimLeave *
    \ if filereadable(expand('~/.vim/.netrwhist'))
    \ |   call delete(expand('~/.vim/.netrwhist'))
    \ | endif
    \ | for ds_file in globpath('~/.vim/', '**/.DS_Store', 1, 1)
    \ |   call delete(ds_file)
    \ | endfor
augroup END
