-- local icons = LazyVim.config.icons
local icons = require('config.lazy.opts').icons

return {
  {
    'nvim-lualine/lualine.nvim',
    event = 'LazyFile',
    opts = function()
      vim.opt.laststatus = 3
      -- PERF: we don't need this lualine require madness 🤷
      local lualine_require = require('lualine_require')
      lualine_require.require = require
      local opts = {
        options = {
          theme = 'auto',
          -- globalstatus = vim.opt.laststatus == 3,
          globalstatus = true,
          disabled_filetypes = {
            statusline = { 'snacks_dashboard' },
            winbar = { 'lazy', 'snacks_dashboard' },
          },
          section_separators = { left = '', right = '' },
          component_separators = { left = '', right = '' },
        },

        winbar = {
          lualine_a = {
            LazyVim.lualine.pretty_path({
              relative = 'root',
              modified_sign = ' 💾',
              number = 0,
              modified_hl = '',
              directory_hl = '',
              filename_hl = '',
            }),
          },
          lualine_b = { { 'navic', color_correction = 'dynamic' } },
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { LazyVim.lualine.root_dir() },
          lualine_c = {
            {
              'diagnostics',
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
          },

          lualine_x = {
            Snacks.profiler.status(),
            -- stylua: ignore
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = function() return { fg = Snacks.util.color("Special") } end,
            },
          },
          lualine_y = {
            { 'filetype', icon_only = true, separator = '', padding = { left = 1, right = 0 } },
          },
          lualine_z = {
            { 'progress', separator = ' ', padding = { left = 1, right = 0 } },
            { 'location', padding = { left = 0, right = 1 } },
          },
        },
        extensions = { 'lazy', 'fzf' },
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
    opts = function()
      return {
        separator = ' ',
        highlight = true,
        depth_limit = 7,
        icons = icons.kinds,
        lazy_update_context = true,
      }
    end,
  },
  { import = 'lazyvim.plugins.extras.editor.mini-diff' },
  { import = 'lazyvim.plugins.extras.util.mini-hipatterns' },
  -- { import = 'lazyvim.plugins.extras.ui.treesitter-context' },
}
