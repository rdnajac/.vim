" plugin/surround.vim
nmap S viWS
vmap ` S`
vmap F Sf

" toggle 'single' or "double" quotes
nmap cq <Cmd>call execute#inPlace("normal cs\"'")<CR>
nmap cQ <Cmd>call execute#inPlace("normal cs'\"")<CR>

" relies on `cs` from vim-surround
" nmap <expr> cq change#quote()
