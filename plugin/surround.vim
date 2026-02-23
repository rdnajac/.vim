" plugin/surround.vim
if has('nvim') && luaeval('_G.MiniSurround ~= nil')
  nmap ys sa
  nmap ds sd
  nmap cs sr
  " from the docs
  xmap <silent> S :<C-u>lua MiniSurround.add('visual')<CR>
  nmap yss ys_
endif

nmap S viWS
xmap ` S`
xmap F Sf

" toggle 'single' or "double" quotes
nmap cq <Cmd>call vim#with#savedView("normal cs\"'")<CR>
nmap cQ <Cmd>call vim#with#savedView("normal cs'\"")<CR>
