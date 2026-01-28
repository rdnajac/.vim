" plugin/surround.vim
nmap S viWS
vmap ` S`
vmap F Sf

" toggle single/double quotes
" relies on `cs` from vim-surround
nmap <expr> cq change#quote()
