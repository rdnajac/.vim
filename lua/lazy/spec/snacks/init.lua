return {
  'folke/snacks.nvim',
  priority = 1000,
  ---@module "snacks"
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    -- dashboard = require('lazy.spec.snacks.dashboard').config,
    dashboard = { enabled = false },
    -- explorer = { enabled = false },
    explorer = { replace_netrw = false },
    image = { enabled = true },
    indent = { indent = { only_current = true, only_scope = true } },
    input = { enabled = true },
    notifier = { style = 'fancy', date_format = '%T', timeout = 4000 },
    ---@type snacks.picker.Config
    picker = {
      layout = { preset = 'ivy' },
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
              title = '{title} {live} {flags}',
              title_pos = 'left',
            },
            {
              win = 'input',
              height = 1,
            },
          },
        },
      },
      sources = require('lazy.spec.snacks.picker._default').sources,
      win = {
        input = {
          keys = {
            ['<Esc>'] = { 'close', mode = { 'i', 'n' } },
            ['<a-z>'] = {
              function(self)
                require('lazy.spec.snacks.picker.zoxide').cd_and_resume_picking(self)
                -- Snacks.picker.actions.cd(_, item)
                -- Snacks.picker.actions.lcd(_, item)
              end,
              mode = { 'i', 'n' },
            },
          },
        },
        preview = { minimal = true },
      },
    },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = false },
    styles = {
      lazygit = { height = 0, width = 0 },
    },
    terminal = {
      start_insert = true,
      auto_insert = false,
      auto_close = true,
      win = { wo = { winbar = '', winhighlight = 'Normal:SpecialWindow' } },
    },
    words = { enabled = true },
  },
}
