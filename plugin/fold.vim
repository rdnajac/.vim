" plugin/fold.vim
set fillchars+=fold:\ ,
set fillchars+=foldclose:▸,
set fillchars+=foldopen:▾,
set fillchars+=foldsep:\ ,
set fillchars+=foldsep:│
" set foldlevel=99
" set foldlevelstart=2
" set foldminlines=5
set foldopen+=insert,jump
set foldtext=fold#text()
set foldmethod=marker

nnoremap          zv zMzvzz
nnoremap <silent> zj zcjzOzz
nnoremap <silent> zk zckzOzz

nnoremap <leader>df <Cmd>call fold#status()<CR>

" open closed folds with in normal mode
nnoremap <expr> h      fold#open_or_h()
" nnoremap <expr> <Left> fold#open_or_h()

" better search if auto pausing folds
" set foldopen-=search
" nnoremap <silent> / zn/

augroup vimrc_fold
  au!
  au FileType lua setl fdm=expr fdl=99 fml=5
  au FileType sh  setl fdm=expr
  " au FileType vim setl fdm=marker
augroup END
