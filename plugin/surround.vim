" plugin/surround.vim
if has('nvim') && luaeval('package.loaded["which-key"] ~= nil')
  xmap <silent> S :<C-U>lua MiniSurround.add('visual')<CR>
  nmap yss ys_
endif

nmap S viWS
xmap ` S`
xmap F Sf

" toggle 'single' or "double" quotes
nmap cq <Cmd>call execute#inPlace("normal cs\"'")<CR>
nmap cQ <Cmd>call execute#inPlace("normal cs'\"")<CR>

" relies on `cs` from vim-surround
" nmap <expr> cq change#quote()
