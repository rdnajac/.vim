local M = { 'folke/snacks.nvim' }

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
    -- replace_netrw = false,
    replace_netrw = vim.g.default_file_explorer == 'snacks',
  },
  image = {
    enabled = false,
  },
  indent = {
    enabled = true,
    indent = { only_current = true, only_scope = true },
  },
  input = {
    enabled = true,
  },
  notifier = {
    enabled = true,
    style = 'fancy',
    date_format = '%T',
    timeout = 4000,
  },
  ---@type snacks.picker.Config
  picker = {
    layout = { preset = 'ivy' },
    layouts = require('nvim.snacks.config.layouts'),
    sources = require('nvim.snacks.config.pickers'),
    win = require('nvim.snacks.config.win'),
    ---@class snacks.picker.debug
    debug = {
      scores = false, -- show scores in the list
      leaks = true, -- show when pickers don't get garbage collected
      explorer = true, -- show explorer debug info
      files = true, -- show file debug info
      grep = true, -- show file debug info
      proc = true, -- show proc debug info
      extmarks = false, -- show extmarks errors
    },
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
    terminal = require('nvim.snacks.config.styles').terminal,
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
  require('snacks').setup(M.opts)
end

return M
