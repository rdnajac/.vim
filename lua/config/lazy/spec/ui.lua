return {
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then -- set an empty statusline till lualine loads
        vim.o.statusline = ' '
      else
        -- BUG: what happens if cmdheight is 0?
        vim.o.laststatus = 0 -- hide the statusline on the starter page
      end
    end,
    opts = function()
      -- PERF: we don't need this lualine require madness 🤷
      local lualine_require = require('lualine_require')
      lualine_require.require = require

      local icons = LazyVim.config.icons

      vim.o.laststatus = vim.g.lualine_laststatus

      local opts = {
        options = {
          theme = 'auto',
          globalstatus = vim.o.laststatus == 3,
          disabled_filetypes = { statusline = { 'snacks_dashboard' } },
          section_separators = { left = '', right = '' },
          component_separators = { left = '', right = '' },
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = {
            LazyVim.lualine.root_dir(),
            LazyVim.lualine.pretty_path({
              relative = 'root',
              modified_sign = ' 💾',
              number = 4,
            }),
          },
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
          -- lualine_z = {
          --   function()
          --     return ' ' .. os.date('%R')
          --   end,
          -- },
        },
        extensions = { 'lazy', 'fzf' },
      }
      return opts
    end,
  },
  { import = 'lazyvim.plugins.extras.editor.mini-diff' },
  { import = 'lazyvim.plugins.extras.editor.navic' },
  { import = 'lazyvim.plugins.extras.util.mini-hipatterns' },
  -- { import = 'lazyvim.plugins.extras.ui.treesitter-context' },
}
