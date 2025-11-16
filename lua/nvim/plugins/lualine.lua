local winbar = require('nvim.util.winbar')
-- TODO: https://github.com/nvim-lualine/lualine.nvim/wiki/Component-snippets
local M = {
  'nvim-lualine/lualine.nvim',
  opts = function()
    local opts = {
      options = {
        -- component_separators = nv.icons.sep.component.rounded,
        -- section_separators = nv.icons.sep.section.rounded,
        section_separators = { left = '', right = '' },
        disabled_filetypes = { -- Filetypes to disable lualine for.
          statusline = {},
          winbar = { 'netrw' },
        },
        ignore_focus = {
	  'man',
          'help',
        },
        theme = {
          normal = {
            a = 'Chromatophore_a',
            b = 'Chromatophore_b',
            c = 'Chromatophore_c',
          },
          -- inactive = {
          --   a = 'Chromatophore_a',
          --   b = 'Chromatophore_b',
          --   c = 'Chromatophore_c',
          -- },
          inactive = {
            a = 'Chromatophore_b',
            b = 'Chromatophore_c',
            c = 'Chromatophore',
          },
        },
        -- use_mode_colors = false,
      },
      sections = {},
      inactive_sections = {},
      tabline = {
        lualine_a = {
          { '%{fnamemodify(getcwd(), ":~:h").."/"}', color = { fg = '#000000', gui = 'bold' } },
        },
        lualine_b = { 'tabs' },
      },
      winbar = winbar.lualine_winbar,
      inactive_winbar = winbar.lualine_inactive_winbar,
      extensions = winbar.lualine_extensions,
    }
    -- local man = require('lualine/extensions/man')
    -- man.winbar = man.sections
    -- vim.list_extend(opts.extensions, man)
    return opts
  end,
}

return M
