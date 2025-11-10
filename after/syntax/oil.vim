" ~/.vim/after/syntax/oil.vim
  " TODO: generate the correct fticon
  " TODO: syntax/dirvish.vim
if expand('%:p') =~# '/.local/state/nvim/backup/'
  " Show / for slashes
  syn match oilSlash /%/ conceal cchar=/
  " hide .bak extension
  syn match oilBak /.bak/ conceal
endif
