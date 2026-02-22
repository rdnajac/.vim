" plugin/surround.vim
if has('nvim') && luaeval('_G.MiniSurround ~= nil')
  xmap <silent> S :<C-U>lua MiniSurround.add('visual')<CR>
  nmap yss ys_
endif

nmap S viWS
xmap ` S`
xmap F Sf

" toggle 'single' or "double" quotes
nmap cq <Cmd>call vim#with#savedView("normal cs\"'")<CR>
nmap cQ <Cmd>call vim#with#savedView("normal cs'\"")<CR>
