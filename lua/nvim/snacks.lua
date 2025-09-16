local M = { 'folke/snacks.nvim' }

-- stylua: ignore
local enabled = {
  bigfile      = { enabled = true },
  dashboard    = { enabled = true },
  explorer     = { enabled = true },
  image        = { enabled = true },
  indent       = { enabled = true },
  input        = { enabled = true },
  notifier     = { enabled = true },
  quickfile    = { enabled = true },
  scope        = { enabled = true },
  scroll       = { enabled = true },
  statuscolumn = { enabled = false },
  words        = { enabled = true },
}

---@module "snacks"
---@type snacks.config
local opts = {
  dashboard = require('nvim.snacks.dashboard'),
  explorer = { replace_netrw = vim.g.default_file_explorer == 'snacks' },
  indent = { indent = { only_current = true, only_scope = true } },
  -- notifier = { style = 'fancy', date_format = '%T', timeout = 4000 },
  picker = require('nvim.snacks.picker'),
  scratch = {
    template = table.concat({
      'local pr = function(...) return print(vim.inspect(...)) end',
      'local x = ',
      '',
      'print(x)',
    }, '\n'),
  },
  terminal = { start_insert = false, auto_insert = true, auto_close = true },
  styles = {
    dashboard = { wo = { winhighlight = 'WinBar:NONE' } },
    lazygit = { height = 0, width = 0 },
    terminal = { wo = { winbar = '', winhighlight = 'Normal:Character' } },
  },
}

-- TODO: use the config merge functions in utils
M.opts = vim.tbl_deep_extend('force', opts, enabled)

M.after = function()
  -- set up global backtrace for debugging
  _G.bt = Snacks.debug.backtrace
  -- override vim.print
  -- vim.print = Snacks.debug.print
  require('nvim.snacks.commands')
  require('nvim.snacks.keymaps')
end


return M
