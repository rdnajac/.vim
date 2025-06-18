return {
  {
    'nvim-lualine/lualine.nvim',
    event = { 'LazyFile', 'VeryLazy' },
    opts = function()
      local x = require('lazy.spec.lualine.extensions')
      -- PERF: we don't need this lualine require madness 🤷
      local lualine_require = require('lualine_require')
      lualine_require.require = require

      vim.opt.showtabline = 2
      vim.opt.showcmdloc = 'statusline'

      local opts = {
        options = {
          theme = require('lazy.spec.lualine.theme'),
          globalstatus = true,
          always_show_tabline = true,
          disabled_filetypes = {
            statusline = { 'help', 'man', 'snacks_dashboard' },
            winbar = { 'oil', 'snacks_terminal', 'snacks_dashboard'},
            -- tabline = { 'snacks_dashboard' },
          },
          section_separators = {},
          component_separators = { left = '', right = '' },
        },
        tabline = require('lazy.spec.lualine.tabline'),
        sections = require('lazy.spec.lualine.statusline'),
        winbar = require('lazy.spec.lualine.winbar').active,
        inactive_winbar = require('lazy.spec.lualine.winbar').inactive,

        extensions = {
          'fugitive',
          'lazy',
          'mason',
          x.man,
          x.oil,
          x.snacks_terminal,
        },
      }
      return opts
    end,
  },
  {
    'SmiteshP/nvim-navic',
    lazy = true,
    init = function()
      vim.g.navic_silence = true
    end,
  },
}
