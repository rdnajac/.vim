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

local oil_ext = {
  winbar = {
    -- lualine_a = { { function() return '🧪' end, }, },
    lualine_b = {
      function()
        local oildir = require('oil').get_current_dir()
        if oildir then
          return vim.fn.fnamemodify(oildir, ':~')
        end
      end,
    },
  },
  filetypes = { 'oil' },
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
        },
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
      },

      winbar = {
        lualine_a = {
          {
            function()
              local icon = '󱉭 '
              local root = LazyVim.root.get({ normalize = true })
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
            return LazyVim.lualine.pretty_path({
              relative = 'root',
              modified_sign = ' 💾',
              length = 9,
              modified_hl = '',
              directory_hl = '',
              filename_hl = '',
            })()
          end,
        },
        lualine_c = { { 'navic', color_correction = 'dynamic' } },

        lualine_y = {
          {
            'diagnostics',
            symbols = {
              error = LazyVim.config.icons.diagnostics.Error,
              warn = LazyVim.config.icons.diagnostics.Warn,
              info = LazyVim.config.icons.diagnostics.Info,
              hint = LazyVim.config.icons.diagnostics.Hint,
            },
          },
        },
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
            symbols = {
              added = LazyVim.config.icons.git.added,
              modified = LazyVim.config.icons.git.modified,
              removed = LazyVim.config.icons.git.removed,
            },
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
          {
            -- require('noice').api.status.mode.get,
            function()
              local val = require('noice').api.statusline.mode.get()
              return val:match('^recording @.+') and val or ''
            end,
            cond = require('noice').api.status.mode.has,
            color = function()
              return { fg = Snacks.util.color('Statement') }
            end,
          },
          {
            require('noice').api.status.command.get,
            cond = require('noice').api.status.command.has,
            color = function()
              return { fg = Snacks.util.color('Statement') }
            end,
          },
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
        lualine_z = {
          { 'progress', separator = ' ', padding = { left = 1, right = 0 } },
          { 'location', padding = { left = 0, right = 1 } },
        },
      },
      extensions = { 'fugitive', 'lazy', man_ext, 'mason', oil_ext, snacks_terminal_ext },
    }
    return opts
  end,
}
