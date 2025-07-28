---@module "snacks"
---@type snacks.Config
local opts = {
  bigfile = {
    enabled = true,
  },
  -- TODO: dashboard and winborder
  dashboard = {
    enabled = true,
    sections = {
      -- { section = 'header', highlight = 'Chromatophore' },
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
  input = { enabled = true },
  notifier = {
    enabled = false,
    style = 'fancy',
    date_format = '%T',
    timeout = 4000,
  },
  ---@type snacks.picker.Config
  picker = {
    win = require('munchies.picker.win'),
    layout = { preset = 'ivy' }, -- default layout for pickers
    layouts = {
      ---@type snacks.picker.layout.Config
      mylayout = {
        reverse = true,
        layout = {
          box = 'vertical',
          backdrop = false,
          height = 0.4,
          row = vim.o.lines - math.floor(0.4 * vim.o.lines),
          {
            win = 'list',
            border = 'rounded',
            -- TODO: set titles in picker calls
            -- title = '{title} {live} {flags}',
            title_pos = 'left',
          },
          {
            win = 'input',
            height = 1,
          },
        },
        {
          win = 'input',
          height = 1,
        },
      },
    },
    ---@type snacks.picker.sources.Config|{}|table<string, snacks.picker.Config|{}>
    sources = {
      explorer = require('munchies.explorer'),
      files = {
        config = function(opts)
          local cwd = opts.cwd or vim.loop.cwd()
          ---@diagnostic disable-next-line: param-type-mismatch
          opts.title = ' Find [ ' .. vim.fn.fnamemodify(cwd, ':~') .. ' ]'
          return opts
        end,
        follow = true,
        hidden = false,
        ignored = false,
        actions = {
          toggle = function(self)
            toggle(self)
          end,
        },
      },
      grep = {
        config = function(opts)
          local cwd = opts.cwd or vim.loop.cwd()
          ---@diagnostic disable-next-line: param-type-mismatch
          opts.title = '󰱽 Grep (' .. vim.fn.fnamemodify(cwd, ':~') .. ')'
          return opts
        end,
        follow = true,
        hidden = false,
        ignored = false,
        actions = {
          toggle = function(self)
            toggle(self)
          end,
        },
      },
      icons = {
        layout = {
          layout = {
            reverse = true,
            relative = 'cursor',
            row = 1,
            width = 0.3,
            min_width = 48,
            height = 0.3,
            border = 'none',
            box = 'vertical',
            { win = 'input', height = 1, border = 'rounded' },
            { win = 'list', border = 'rounded' },
          },
        },
      },
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
    terminal = require('munchies.styles').terminal,
  },
  terminal = {
    start_insert = true,
    auto_insert = true,
    auto_close = true,
    win = { wo = { winbar = '', winhighlight = 'Normal:SpecialWindow' } },
  },
  words = { enabled = true },
}

require('snacks').setup(opts)
require('munchies.chromatophore')
-- vim:set fdl=2
