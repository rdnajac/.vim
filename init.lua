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
  :map(function(mname) return mname, require('nvim.' .. mname) end)
  :fold({}, rawset) -- inits an empty table and maps `nv[nvim.k] = v`
-- local _, mod = xpcall(require, debug.traceback, 'nvim.' .. modname)

vim.keymap.set({ 'n', 'x' }, { 'j', '<Down>' }, [[v:count ? 'j' : 'gj']], { expr = true })
vim.keymap.set({ 'n', 'x' }, { 'k', '<Up>' }, [[v:count ? 'k' : 'gk']], { expr = true })
