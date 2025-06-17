local has_noice, noice = pcall(require, 'noice')

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
      local opts = {
        options = {
          theme = 'auto',
          globalstatus = true,
          always_show_tabline = true,
          disabled_filetypes = {
            statusline = { 'help', 'man', 'snacks_dashboard' },
            winbar = { 'lazy', 'mason', 'snacks_dashboard', 'snacks_terminal' },
            tabline = { 'snacks_dashboard' },
          },
          section_separators = {},
          -- component_separators = {},
          -- section_separators = { left = '', right = '' },
          -- section_separators = { left = '', right = '' },
          component_separators = { left = '', right = '╱' },
          section_separators = { left = '🭛', right = '🭋' },
        },

        tabline = {
          lualine_a = { require('lazy.spec.lualine.path').prefix },
          lualine_b = { require('lazy.spec.lualine.path').suffix },
          lualine_c = { { 'navic', color_correction = 'dynamic' } },
          lualine_y = { { 'diagnostics', symbols = LazyVim.config.icons.diagnostics } },
          lualine_z = {
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
        },

        sections = {
          lualine_a = { 'mode' },
          lualine_b = {
            {
              function()
                return vim.fn.fnamemodify(vim.fn.getcwd(), ':~')
              end,
            },
            -- { 'branch' },
          },
          lualine_c = {
            Snacks.profiler.status(),
            {
              'diff',
              symbols = LazyVim.config.icons.git,
              source = function()
                local summary = vim.b.minidiff_summary
                return summary
                    and {
                      added = summary.add,
                      modified = summary.change,
                      removed = summary.delete,
                    }
                  or nil
              end,
            },
          },

          lualine_x = {
            -- TODO: this but without noice
            -- {
            --   function()
            --     local val = noice.api.statusline.mode.get()
            --     return val:match('^recording @.+') and val or ''
            --   end,
            --   cond = has_noice and noice.api.statusline.mode.has,
            --   color = function()
            --     return { fg = Snacks.util.color('Statement') }
            --   end,
            -- },
            -- {
            --   noice.api.status.command.get,
            --   cond = has_noice and noice.api.status.command.has,
            --   color = function()
            --     return { fg = Snacks.util.color('Statement') }
            --   end,
            -- },

            {
              '%S',
              color = function()
                return { fg = Snacks.util.color('String') }
              end,
            },
            {
              function()
                local reg = vim.fn.reg_recording()
                return reg ~= '' and 'recording @' .. reg or ''
              end,
              color = { fg = '#ff3344', gui = 'bold' },
              cond = function()
                return vim.fn.reg_recording() ~= ''
              end,
            },
          },
          lualine_y = {
            {
              function()
                for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
                  if client.name == 'GitHub Copilot' then
                    return LazyVim.config.icons.kinds.Copilot
                  end
                end
                return ' '
              end,
            },
            -- TODO: treesitter status
            {
              'lsp_status',
              icon = ' ',
              symbols = { done = '' },
              ignore_lsp = { 'GitHub Copilot' },
            },
            {
              'filetype',
              icon_only = true,
              separator = '',
              padding = { left = 1, right = 0 },
            },
          },
          -- lualine_z = { { 'selectioncount' }, { 'progress' }, { 'location' } },
          lualine_z = {},
        },
        extensions = { 'fugitive', 'lazy', man_ext, 'mason', snacks_terminal_ext },
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
        icons = LazyVim.config.icons.kinds,
        lazy_update_context = true,
      }
    end,
  },
}
