" plugin/fold.vim
set fillchars+=fold:\ ,
set fillchars+=foldclose:▸,
set fillchars+=foldopen:▾,
set fillchars+=foldsep:\ ,
set fillchars+=foldsep:│
set foldlevel=99
" set foldlevelstart=2
" set foldminlines=5
set foldopen+=insert,jump
set foldtext=fold#text()
" set foldmethod=marker

augroup vimrc_fold
  au!
  " auto_pause_folds
  " au CmdlineLeave /,\? call fold#pause()
  " au CursorMoved,CursorMovedI * call fold#unpause()
  au FileType lua setl fdm=expr
  au FileType sh  setl fdm=expr
  au FileType vim setl fdm=marker
augroup END

nnoremap <expr> h fold#open_or_h()

" better search if auto pausing folds
" set foldopen-=search
" nnoremap <silent> / zn/
