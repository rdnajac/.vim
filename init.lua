--- init.lua
vim.loader.enable()
vim.cmd([[so ~/.vim/vimrc]])
_G.dd = Snacks and Snacks.debug.inspect or vim.print
_G.bt = Snacks and Snacks.debug.backtrace or require('nvim.util.debug').trace
_G.nv = require('nvim')
