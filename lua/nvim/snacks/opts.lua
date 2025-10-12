--- @type snacks.Config
return {
  bigfile = { enabled = true },
  dashboard = require('nvim.snacks.dashboard'),
  explorer = { replace_netrw = false }, -- using `oil` instead
  indent = { indent = { only_current = true, only_scope = true } },
  input = { enabled = true },
  notifier = { enabled = false },
  -- notifier = require('nvim.snacks.notifier'),
  quickfile = { enabled = true },
  scratch = { template = 'local x = \n\nprint(x)' },
  terminal = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = { enabled = false },
  picker = require('nvim.snacks.picker'),
  styles = {
    dashboard = { wo = { winhighlight = 'WinBar:NONE' } },
    lazygit = { height = 0, width = 0 },
    terminal = { wo = { winbar = '', winhighlight = 'Normal:Character' } },
  },
  words = { enabled = true },
}
