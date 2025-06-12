---@module "snacks"
return {
  'folke/snacks.nvim',
  priority = 1000,
  opts = {
    bigfile = { enabled = true },
    dashboard = require('lazy.spec.snacks.dashboard').config,
    explorer = { enabled = false },
    image = { enabled = true },
    indent = { indent = { only_current = true, only_scope = true } },
    input = { enabled = true },
    notifier = { style = 'fancy', date_format = '%T', timeout = 4000 },
    picker = require('lazy.spec.snacks.picker').config,
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    terminal = {
      start_insert = true,
      auto_insert = false,
      auto_close = true,
      win = { wo = { winbar = '', winhighlight = 'Normal:SpecialWindow' } },
    },
    words = { enabled = true },
  },
}
