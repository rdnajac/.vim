" plugin/surround.vim
nmap S viWS
vmap ` S`
vmap F Sf

" toggle 'single' or "double" quotes
nmap cq cs"'
nmap cQ cs'"

" relies on `cs` from vim-surround
" nmap <expr> cq change#quote()
