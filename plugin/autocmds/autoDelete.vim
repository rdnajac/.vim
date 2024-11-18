" plugin/autocmds/autoDelete.vim
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
