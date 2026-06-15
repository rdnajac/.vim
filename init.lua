vim.o.exrc = true
vim.loader.enable()
vim.cmd.run('vimrc')
require('snacks')
_G.dd = Snacks.debug
_G.bt = dd.backtrace
_G.nv =  require('nvim.util')
nv.ui = require('nvim.ui')
nv.ui['2'].setup()
-- nv.opts = vim.defaulttable()
