--- init.lua
vim.loader.enable()
require('vim._core.ui2').enable({ msg = { targets = 'msg' } })

vim.cmd([[source ~/.vim/vimrc]])

_G.dd = require('snacks.debug')
_G.bt = dd.backtrace

_G.nv = require('nvim')

nv.status = require('nvim.status')
nv.ui = { icons = require('nvim.ui.icons') }
