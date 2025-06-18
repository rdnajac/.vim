return {
  lualine_a = { require('lazy.spec.lualine.path').prefix },
  lualine_b = {
    require('lazy.spec.lualine.path').suffix,
    require('lazy.spec.lualine.path').modified,
    {
      'navic',
      color_correction = 'dynamic',
      navic_opts = {
        depth_limit = 7,
        depth_limit_indicator = LazyVim.config.icons.misc.dots,
        highlight = false, -- must be false for color to apply
        icons = LazyVim.config.icons.kinds,
        lazy_update_context = false,
        separator = '  ',
      },
      color = { bg = '#000000' },
    },
  },
  lualine_x = { { 'diagnostics', symbols = LazyVim.config.icons.diagnostics, color = { bg = 'NONE' } } },
  lualine_c = {},
  lualine_y = {
    { -- display the number of plugins that have pending updates
      function()
        if require('lazy.status').has_updates() then
          return require('lazy.status').updates() .. ' 󰒲 '
        end
        return ''
      end,
      cond = require('lazy.status').has_updates,
    },
  },
}
