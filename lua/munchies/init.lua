---@module "snacks"
---@type snacks.Config
local opts = {
  bigfile = { enabled = true },
  dashboard = { enabled = false },
  -- dashboard = require('munchies.dashboard').config,
  explorer = { replace_netrw = false },
  image = { enabled = true },
  indent = {
    enabled = true,
    indent = { only_current = true, only_scope = true },
  },
  input = { enabled = true },
  notifier = {
    enabled = false,
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
  },
  terminal = {
    start_insert = true,
    auto_insert = true,
    auto_close = true,
    win = { wo = { winbar = '', winhighlight = 'Normal:SpecialWindow' } },
  },
  words = { enabled = true },
}

local ok, Snacks = pcall(require, 'snacks')
if not ok then
  error('out of snacks: ' .. tostring(Snacks))
end

Snacks.setup(opts)

require('munchies.util') -- exposes global functions
require('munchies.chromatophore')
require('munchies.commands')
require('munchies.keymaps')
require('munchies.toggle')
