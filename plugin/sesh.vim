let g:sesh = fnamemodify($MYVIMRC, ':p:h') . '/Session.vim'

augroup Obsess
  autocmd!
  autocmd VimEnter * if argc() == 0 && filereadable(g:sesh) |
        \   execute 'silent! source ' . fnameescape(g:sesh) |
        \   if filereadable(expand('%:p')) |
        \     call timer_start(1, { -> execute('edit') }) |
        \   endif |
        \ endif
augroup END
