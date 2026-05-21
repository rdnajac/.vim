--- init.lua
vim.loader.enable()
vim.cmd([[so ~/.vim/vimrc]])
require('snacks')
_G.dd = Snacks.debug.inspect
_G.bt = Snacks.debug.backtrace
_G.nv = require('nvim')
