local theme = {
  normal = {
    a = 'Chromatophore_a',
    b = 'Chromatophore_b',
    c = 'Chromatophore_c',
  },
  inactive = {
    a = 'Chromatophore_b',
    b = 'Chromatophore_c',
    c = 'StatusLine',
  },
}

local winbar = require('nvim.util.winbar')
return {
  'nvim-lualine/lualine.nvim',
  opts = {
    options = {
      theme = theme,
      -- component_separators = nv.icons.sep.component.rounded,
      -- section_separators = nv.icons.sep.section.rounded,
      section_separators = { left = '', right = '' },
      use_mode_colors = false,
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
  },
  after = function()
    vim.cmd([[
      highlight! link lualine_transitional_lualine_a_normal_to_StatusLine Chromatophore_a
      ]])
  end,
}
