--- init.lua
vim.loader.enable()
vim.cmd([[so ~/.vim/vimrc]])
vim.cmd([[pa  snacks.nvim]])
_G.bt = Snacks.debug.backtrace
_G.dd = Snacks.debug.inspect
_G.fn = vim.fn
_G.nv = vim
  .iter(fn.readdir(vim.fs.joinpath(fn.stdpath('config'), 'lua', 'nvim')))
  :map(function(fname) return fn.fnamemodify(fname, ':r') end)
  :map(function(mname) return mname, require('nvim.' .. mname) end)
  :fold({}, rawset) -- inits an empty table and maps `nv[nvim.k] = v`


require('blink')
require('mini')

vim.o.exrc = true
