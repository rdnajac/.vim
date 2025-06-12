return {
  -- { import = 'config.lazy.spec.ui.edgy' },
  { import = 'config.lazy.spec.ui.lualine' },
  -- { import = 'config.lazy.spec.ui.noice' },
  { import = 'lazyvim.plugins.extras.util.mini-hipatterns' },
  -- { import = 'lazyvim.plugins.extras.ui.treesitter-context' },
  {
    'SmiteshP/nvim-navic',
    lazy = true,
    init = function()
      vim.g.navic_silence = true
    end,
    opts = function()
      return {
        separator = ' ',
        highlight = true,
        depth_limit = 7,
        icons = LazyVim.config.icons.kinds,
        lazy_update_context = true,
      }
    end,
  },
}
