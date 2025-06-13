require('lazy.file')

return {
  {
    'LazyVim/LazyVim',
    priority = 9999,
    -- HACK: override the default LazyVim config entirely
    config = function()
      _G.LazyVim = require('lazyvim.util')
      LazyVim.config = require('lazy.opts')
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
    opts = {
      bigfile = { enabled = true },
      dashboard = require('munchies.dashboard').config,
      explorer = { enabled = false },
      image = { enabled = true },
      indent = { indent = { only_current = true, only_scope = true } },
      input = { enabled = true },
      notifier = { style = 'fancy', date_format = '%T', timeout = 4000 },
      picker = require('munchies.picker').config,
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
