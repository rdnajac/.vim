---@module "snacks"

local M = {}

---@type snacks.Config
M.opts = {
  bigfile = require('folke.snacks.bigfile'),
  dashboard = require('folke.snacks.dashboard'),
  explorer = { replace_netrw = true },
  image = { enabled = true },
  indent = { indent = { only_current = false, only_scope = true } },
  input = { enabled = true },
  -- notifier = require('folke.snacks.notifier'),
  quickfile = { enabled = true },
  scratch = { template = 'local x = \n\nprint(x)' },
  terminal = { enabled = true },
  scope = {
    keys = {
      textobject = {
        ii = { min_size = 2, edge = false, cursor = false, desc = 'inner scope' },
        ai = { min_size = 2, cursor = false, desc = 'full scope' },
        -- ag = { min_size = 1, edge = false, cursor = false, treesitter = { enabled = false }, desc = "buffer" },
      },
      jump = {
        ['[i'] = { min_size = 1, bottom = false, cursor = false, edge = true },
        [']i'] = { min_size = 1, bottom = true, cursor = false, edge = true },
      },
    },
  },
  scroll = { enabled = true },
  statuscolumn = require('folke.snacks.statuscolumn'),
  picker = require('folke.snacks.picker'),
  styles = {
    lazygit = { height = 0, width = 0 },
    terminal = { wo = { winhighlight = 'Normal:Character' } },
    notification_history = { height = 0.9, width = 0.9, wo = { wrap = false } },
  },
  words = { enabled = true },
}

M.config = function() require('snacks').setup(M.opts) end

return M
