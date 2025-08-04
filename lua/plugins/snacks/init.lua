local M = { 'folke/snacks.nvim' }

M.priority = 1000

---@module "snacks"
---@type snacks.Config
M.opts = {
  bigfile = {
    enabled = true,
  },
  dashboard = {
    enabled = false,
    sections = {
      { section = 'header' },
      { section = 'recent_files' },
      { padding = 1 },
      {
        section = 'terminal',
        -- TODO: get `gf` to work with variable expansions
        cmd = vim.fn.stdpath('config') .. '/bin/cowsay-vim-fortunes',
        height = 13,
      },
    },
  },
  explorer = {
    enabled = true,
    replace_netrw = false,
  },
  image = {
    enabled = true,
  },
  indent = {
    enabled = true,
    indent = { only_current = true, only_scope = true },
  },
  input = {
    enabled = true,
  },
  notifier = {
    enabled = false,
    style = 'fancy',
    date_format = '%T',
    timeout = 4000,
  },
  ---@type snacks.picker.Config
  picker = {
    sources = require('plugins.snacks.pickers'),
    layout = { preset = 'ivy' }, -- default layout for pickers
    layouts = {},
    win = require('munchies.picker.win'),
  },
  quickfile = { enabled = true },
  scope = { enabled = true },
  scratch = {
    ---@type table<string, snacks.win.Config>
    win_by_ft = {
      vim = {
        keys = {
          ['source'] = {
            '<cr>',
            function(_)
              -- TODO: use `PP`
              vim.cmd.source('%')
            end,
            desc = 'Source buffer',
            mode = { 'n', 'x' },
          },
        },
      },
    },
  },
  scroll = { enabled = true },
  statuscolumn = { enabled = false },
  styles = {
    lazygit = { height = 0, width = 0 },
    terminal = require('plugins.snacks.styles').terminal,
  },
  terminal = {
    start_insert = true,
    auto_insert = true,
    auto_close = true,
    win = { wo = { winbar = '', winhighlight = 'Normal:SpecialWindow' } },
  },
  words = { enabled = true },
}

M.config = function()
  -- setup makes the global `Snacks` table available
  require('snacks').setup(M.opts)

  -- use the included icons for other plugins
  local icons = require('snacks.picker.config.defaults').defaults.icons

  -- merge with the icons from nvim.icons
  _G.icons = vim.tbl_deep_extend('force', {}, icons, require('nvim.icons'))

  -- setup debug functions
  _G.bt = function()
    Snacks.debug.backtrace()
  end

  _G.dd = function(...)
    return (function(...)
      return Snacks.debug.inspect(...)
    end)(...)
  end

  vim.print = _G.dd
end

return M
-- vim:fdm=indent fdl=1
