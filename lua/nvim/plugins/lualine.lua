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
        disabled_filetypes = { -- Filetypes to disable lualine for.
          statusline = {},
          winbar = { 'netrw', 'snacks_dashboard', 'snacks_picker_input' },
        },
        ignore_focus = {
          -- 'man',
          -- 'help',
        },
        theme = {
          normal = {
            a = 'Chromatophore_a',
            b = 'Chromatophore_b',
            c = 'Chromatophore_c',
          },
        },
        -- use_mode_colors = false,
      },
      -- sections = {},
      inactive_sections = {},
      tabline = {
        lualine_a = {
          { '%{fnamemodify(getcwd(), ":~:h").."/"}', color = { fg = '#000000', gui = 'bold' } },
        },
        lualine_b = { 'tabs' },
        lualine_c = { Snacks.profiler.status() },
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
        lualine_c = { 'diagnostics' },
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
