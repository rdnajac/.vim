" let g:sesh = fnamemodify($MYVIMRC, ':p:h') . '/Session.vim'
"
" augroup Obsess
"   autocmd!
"   autocmd VimEnter * if argc() == 0 && filereadable(g:sesh) |
"         \ execute 'silent! source ' . fnameescape(g:sesh) |
"         \ call timer_start(1, { -> execute("bufdo if buflisted(bufnr('%')) && bufwinnr(bufnr('%')) > 0 | edit | endif") }) |
"         \ endif
" augroup END
