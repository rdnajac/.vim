--- init.lua
vim.loader.enable()

vim.cmd([[source ~/.vim/vimrc]])

require('snacks')
_G.bt = Snacks.debug.backtrace
_G.dd = Snacks.debug.inspect

local fn = vim.fn

_G.nv = vim
  .iter(fn.readdir(fn.stdpath('config') .. '/lua/nvim'))
  :map(function(s) return fn.fnamemodify(s, ':r') end)
  -- :filter(function(mname) return mname ~= 'init' end)
  :map(function(mname) return mname, require('nvim.' .. mname) end)
  :fold({}, rawset) -- inits an empty table and maps `nv[nvim.k] = v`
-- local _, mod = xpcall(require, debug.traceback, 'nvim.' .. modname)
