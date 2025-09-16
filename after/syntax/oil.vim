" ~/.vim/after/syntax/oil.vim

" convert the % symbols in the backup filenames 
if expand('%:p') =~# '/.local/state/nvim/backup/'
  syn match oilSlash /%/ conceal cchar=/
endif
