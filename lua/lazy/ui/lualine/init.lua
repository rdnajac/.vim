return {
  {
    'nvim-lualine/lualine.nvim',
    enabled = false,
    event = { 'LazyFile', 'VeryLazy' },
    opts = function()
      local x = require('spec.lualine.extensions')
      -- PERF: we don't need this lualine require madness 🤷
      local lualine_require = require('lualine_require')
      lualine_require.require = require

      vim.opt.showtabline = 2
      vim.opt.showcmdloc = 'statusline'
      vim.g.navic_silence = true

      local opts = {
        options = {
          theme = require('spec.lualine.theme'),
          -- globalstatus = true,
          always_show_tabline = true,
          disabled_filetypes = {
            statusline = { 'help', 'man', 'snacks_dashboard' },
            winbar = { 'oil', 'snacks_terminal', 'snacks_dashboard' },
            -- tabline = { 'snacks_dashboard' },
          },
          section_separators = {},
          component_separators = { left = '', right = '' },
        },
        -- sections = require('spec.lualine.statusline'),
        -- sections = {},
        tabline = {
          lualine_a = { require('spec.lualine.components.path').prefix },
          lualine_b = {
            require('spec.lualine.components.path').suffix,
            require('spec.lualine.components.path').modified,
          },
          -- lualine_c = {},
          lualine_x = {},
          lualine_y = { require('spec.lualine.components.lazy_updates') },
          lualine_z = require('spec.lualine.components.time').clock,
        },
        winbar = require('spec.lualine.winbar').active,
        inactive_winbar = require('spec.lualine.winbar').inactive,

        extensions = {
          'fugitive',
          'lazy',
          'mason',
          x.checkhealth,
          x.man,
          x.oil,
          x.snacks_terminal,
        },
      }
      return opts
    end,
  },
}
