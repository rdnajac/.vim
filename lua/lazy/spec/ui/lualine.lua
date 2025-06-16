local icons = require('lazy.config').icons.diagnostics
-- local icons = LazyVim.config.icons.diagnostics

local has_noice, noice = pcall(require, 'noice')

local man_ext = {
  winbar = {
    lualine_a = {
      function()
        return 'MAN'
      end,
    },
    lualine_b = { { 'filename', file_status = false } },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
  filetypes = { 'man' },
}

local snacks_terminal_ext = {
  sections = {
    lualine_a = {
      function()
        local chan = vim.b.terminal_job_id or '?'
        return 'term channel: ' .. tostring(chan)
      end,
    },
  },
  filetypes = { 'snacks_terminal' },
}

return {
  {
    'nvim-lualine/lualine.nvim',
    event = { 'LazyFile', 'VeryLazy' },
    opts = function()
      -- PERF: we don't need this lualine require madness 🤷
      local lualine_require = require('lualine_require')
      lualine_require.require = require
      local opts = {
        options = {
          theme = 'auto',
          globalstatus = true,
          disabled_filetypes = {
            statusline = { 'help', 'man', 'snacks_dashboard' },
            winbar = { 'lazy', 'mason', 'snacks_dashboard', 'snacks_terminal' },
            tabline = { 'snacks_dashboard' },
          },
          section_separators = { left = '', right = '' },
          component_separators = { left = '', right = '' },
        },

        tabline = {
          lualine_a = {
            {
              function()
                -- local bufname = vim.api.nvim_buf_get_name(0)
                -- if bufname:match('^oil://') then
                --   return '󰙅 Oil'
                -- end
                -- TODO: display root root dir only
                local icon = '󱉭 '
                local root = LazyVim.root.get({ normalize = false })
                local name = vim.fs.basename(root)
                return icon .. (name and (name .. '/') or '')
              end,
              cond = function()
                local cwd = vim.fn.getcwd()
                local root = LazyVim.root.get({ normalize = true })
                return cwd:find(root, 1, true) == 1
              end,
              color = function()
                return { fg = '#000000', bold = true }
              end,
            },
          },
          lualine_b = {
            function()
              local bufname = vim.api.nvim_buf_get_name(0)
              if bufname:match('^oil://') then
                local oildir = require('oil').get_current_dir()
                return oildir and vim.fn.fnamemodify(oildir, ':~') or bufname
              end
              return LazyVim.lualine.pretty_path({
                relative = 'root',
                modified_sign = ' 💾',
                length = 2,
                modified_hl = '',
                directory_hl = '',
                filename_hl = '',
              })()
            end,
          },
          lualine_c = { { 'navic', color_correction = 'dynamic' } },

          lualine_y = { { 'diagnostics', symbols = LazyVim.config.icons.diagnostics } },
          lualine_z = {
            Snacks.profiler.status(),
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
              function()
                for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
                  if client.name == 'GitHub Copilot' then
                    return LazyVim.config.icons.kinds.Copilot
                  end
                end
                return ''
              end,
            },
          },
          lualine_y = {
            {
              'filetype',
              icon_only = true,
              separator = '',
              padding = { left = 1, right = 0 },
            },
            {
              'lsp_status',
              icon = '',
              symbols = { done = '' },
              ignore_lsp = { 'GitHub Copilot' },
              separator = '',
            },
          },
          -- lualine_z = {
          --   { 'progress', separator = ' ', padding = { left = 1, right = 0 } },
          --   { 'location', padding = { left = 0, right = 1 } },
          -- },
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
