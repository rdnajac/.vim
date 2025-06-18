vim.g.autoformat = true
require('lazy.file')

return {
  {
    'LazyVim/LazyVim',
    priority = 9999,
    -- HACK: override the default LazyVim config entirely
    config = function()
      _G.LazyVim = require('lazyvim.util')
      LazyVim.config = require('lazy.config')
      LazyVim.track('colorscheme')
      require('tokyonight').load()
      LazyVim.track()
      LazyVim.on_very_lazy(function()
        LazyVim.format.setup()
        LazyVim.root.setup()
      end)
    end,
  },
  {
    'folke/snacks.nvim',
    priority = 1000,
    ---@module "snacks"
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      dashboard = require('munchies.dashboard').config,
      explorer = { enabled = false },
      image = { enabled = true },
      indent = { indent = { only_current = true, only_scope = true } },
      input = { enabled = true },
      notifier = { style = 'fancy', date_format = '%T', timeout = 4000 },
      ---@type snacks.picker.Config
      picker = {
        layout = { preset = 'mylayout' },
        layouts = {
          mylayout = require('munchies.picker').layout,
          vscode = require('munchies.picker').layout,
        },
        sources = require('munchies.picker').sources,
        win = {
          input = {
            keys = {
              ['<Esc>'] = { 'close', mode = { 'i', 'n' } },
              ['<a-z>'] = {
                function(self)
                  require('munchies.picker.zoxide').cd_and_resume_picking(self)
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
      statuscolumn = { enabled = true },
      terminal = {
        start_insert = true,
        auto_insert = false,
        auto_close = true,
        win = { wo = { winbar = '', winhighlight = 'Normal:SpecialWindow' } },
      },
      words = { enabled = true },
    },
  },
  { import = 'lazyvim.plugins.extras.util.mini-hipatterns' },
  { 'nvim-lua/plenary.nvim', lazy = true },
}
