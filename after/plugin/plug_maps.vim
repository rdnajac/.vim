" surround shortcuts
vmap `  S`
vmap b  Sb
nmap S  viWS
nmap yss ys_
nmap ycc gccyygcc

if !has('nvim')
  " Start interactive EasyAlign in visual mode (e.g. vipga)
  xmap ga <Plug>(EasyAlign)

  " Start interactive EasyAlign for a motion/text object (e.g. gaip)
  nmap ga <Plug>(EasyAlign)
endif
