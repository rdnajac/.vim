return {

  {
    'nvim-lualine/lualine.nvim',
    event = { 'LazyFile', 'VeryLazy' },
    opts = function()
      vim.opt.showtabline = 2
      vim.opt.showcmdloc = 'statusline'
      -- PERF: we don't need this lualine require madness 🤷
      local lualine_require = require('lualine_require')
      lualine_require.require = require
      local x = require('lazy.spec.lualine.extensions')

      local opts = {
        options = {
          theme = require('lazy.spec.lualine.theme'),
          globalstatus = true,
          always_show_tabline = true,
          disabled_filetypes = {
            statusline = { 'help', 'man', 'snacks_dashboard' },
            winbar = { 'lazy', 'mason', 'snacks_dashboard', 'snacks_terminal' },
            tabline = { 'snacks_dashboard' },
          },
          section_separators = {},
          component_separators = {},
        },

        tabline = require('lazy.spec.lualine.tabline'),
        sections = require('lazy.spec.lualine.statusline'),
        -- sections = require('lazy.spec.lualine.statusline-nocolor'),
        extensions = {
          'fugitive',
          'lazy',
          'mason',
          x.man,
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
