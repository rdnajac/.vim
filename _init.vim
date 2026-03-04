runtime! vimrc
if $PROF == 1
  set rtp+=$HOME/.local/share/nvim/site/pack/core/opt/snacks.nvim
  lua require('snacks.profiler').startup({ startup = { event = 'UIEnter' } })
endif
lua _G.nv = require('nvim')
