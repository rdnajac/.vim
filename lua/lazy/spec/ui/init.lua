return {
  -- { import = 'lazy.spec.ui.edgy' },
  { import = 'lazy.spec.ui.lualine' },
  -- { import = 'lazy.spec.ui.noice' },
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
