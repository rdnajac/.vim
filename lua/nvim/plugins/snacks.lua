local M = { 'folke/snacks.nvim' }
M.priority = 1000

---@module "snacks"

---@type snacks.Config
M.opts = {
  bigfile = { enabled = true },
  dashboard = require('munchies.dashboard').config,
  explorer = { replace_netrw = false },
  image = { enabled = true },
  indent = {
    enabled = true,
    indent = { only_current = true, only_scope = true },
  },
  input = { enabled = true },
  notifier = {
    enabled = true,
    style = 'fancy',
    date_format = '%T',
    timeout = 4000,
  },
  picker = require('munchies.picker').config,
  quickfile = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = { enabled = false },
  styles = {
    lazygit = { height = 0, width = 0 },
    dashboard = { border = 'none' },
  },
  terminal = {
    start_insert = true,
    auto_insert = true,
    auto_close = true,
    win = { wo = { winbar = '', winhighlight = 'Normal:SpecialWindow' } },
  },
  words = { enabled = true },
}

_G.bt = function()
  Snacks.debug.backtrace()
end

_G.dd = function(...)
  return (function(...)
    return Snacks.debug.inspect(...)
  end)(...)
end

vim.print = _G.dd

M.config = function()
  require('snacks').setup(M.opts)
end

return M
