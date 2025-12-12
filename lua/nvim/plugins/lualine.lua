local nv = _G.nv or require('nvim')
-- TODO: https://github.com/nvim-lualine/lualine.nvim/wiki/Component-snippets
local M = {
  'nvim-lualine/lualine.nvim',
  opts = function()
    local opts = {
      options = {
        component_separators = { left = '', right = '' },
        -- section_separators = nv.icons.sep.section.rounded,
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
	  -- FIXME: 
          statusline = { pattern = 'snacks_dashboard' },
          winbar = { 'netrw', 'snacks_dashboard', 'snacks_picker_input' },
          tabline = { 'snacks_dashboard' },
        },
        ignore_focus = {
          -- 'man',
          -- 'help',
        },
        -- theme = {
        --   normal = { a = 'Chromatophore_a', b = 'Chromatophore_b', c = 'Chromatophore_c' },
        -- },
        -- use_mode_colors = false,
      },

      sections = {
        lualine_a = {
          {
            function()
              return nv.path.relative_parts()[1]
            end,
          },
        },
        lualine_b = { nv.path.relative_parts()[2] },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { Snacks.profiler.status() },
      },

      inactive_sections = {},

      tabline = {
        lualine_a = {
          {
            function()
              return vim.fn.fnamemodify(Snacks.git.get_root(), ':p:~')
            end,
            cond = function()
              return vim.bo.filetype ~= 'snacks_dashboard'
            end,
          },
        },
        lualine_b = {
          {
            'tabs',
            -- mode = 0,
            use_mode_colors = true,
            path = 0,
            -- tabs_color = { active = nil, inactive = nil },
            show_modified_status = true,
            symbols = { modified = ',+' },
            cond = function()
              return vim.bo.filetype ~= 'snacks_dashboard'
            end,
          },
        },
        lualine_c = {
          { 'diff', separator = '', cond = function() return vim.bo.filetype ~= 'snacks_dashboard' end },
          { 'diagnostics', separator = '', cond = function() return vim.bo.filetype ~= 'snacks_dashboard' end },
        },
      },

      winbar = {
        lualine_a = { nv.winbar.a },
        lualine_b = {
          {
            function()
              if vim.bo.buftype == 'terminal' then
                return "%{% &buftype == 'terminal' ? ' %{&channel}' : '' %}"
              end
              return "%{% &buflisted ? '%n' : '󱪟 ' %}"
                .. "%{% &bufhidden == '' ? '' : '󰘓 ' %}"
            end,
          },
          nv.treesitter.status,
          nv.lsp.status,
          nv.blink.status,
          -- { require('nvim.plugins.r').status },
        },
      },

      inactive_winbar = {
        lualine_a = { [[%{%v:lua.nv.icons.filetype()%}]] },
        lualine_b = { '%t' },
        -- lualine_c = { M.winbar.b },
      },
      extensions = vim.list_extend({ 'man' }, nv.winbar.lualine_extensions),
    }
    -- local man = require('lualine/extensions/man')
    -- man.winbar = man.sections
    -- vim.list_extend(opts.extensions, man)
    return opts
  end,
}

return M
