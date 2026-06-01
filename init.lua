--- init.lua
vim.loader.enable()

vim.cmd([[source ~/.vim/vimrc]])

require('snacks')
_G.bt = Snacks.debug.backtrace
_G.dd = Snacks.debug.inspect
_G.nv = {
  keys = require('nvim.keys'),
  mini = require('nvim.mini'),
  status = require('nvim.status'),
  ui = require('nvim.ui'),
  util = require('nvim.util'),
}

local status = nv.status
nv.winbar = function()
  return vim.api.nvim_get_current_win() ~= tonumber(vim.g.actual_curwin) and status.buffer()
    or status.render(status.buffer(), status.lsp(), ' ' .. status.treesitter()) .. '%#WinBar# '
end
