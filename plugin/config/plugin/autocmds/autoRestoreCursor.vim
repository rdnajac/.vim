" autocmds/autoRestoreCursor.vim
" Automatically restore cursor position (and open fold) when opening files

augroup autoRestoreCursor
  autocmd!
  autocmd BufReadPost *
        \ let line = line("'\"")
        \ | if line >= 1 && line <= line("$")
        \ |   execute "normal! g`\""
        \ |   execute "silent! normal! zO"
        \ | endif
augroup END
