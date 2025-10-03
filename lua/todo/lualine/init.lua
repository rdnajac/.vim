return {
  'nvim-lualine/lualine.nvim',
  enabled = false,
  opts = function()
    -- PERF: we don't need this lualine require madness 🤷
    local lualine_require = require('lualine_require')
    lualine_require.require = require
    local opts = {
      options = {
        theme = {
          normal = {
            a = 'Chromatophore_a',
            b = 'Chromatophore_b',
            c = 'Chromatophore_c',
          },
          inactive = {
            a = 'Chromatophore_c',
            b = 'Chromatophore_c',
            c = 'Chromatophore_c',
          },
        },
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
        globalstatus = false, -- don’t hijack the statusline
        -- globalstatus = vim.o.laststatus == 3,
        disabled_filetypes = { statusline = { 'snacks_dashboard' } },
      },
      sections = {},
      --   lualine_a = { 'mode' },
      --   lualine_b = { 'branch', 'diff', 'diagnostics' },
      --   lualine_c = { 'filename' },
      --   lualine_x = { 'encoding', 'fileformat', 'filetype' },
      --   lualine_y = { 'progress' },
      --   lualine_z = { 'location' },
      -- },
      inactive_sections = {},
      inactive_winbar = {},
      tabline = {},
      extensions = {},
      winbar = {
        lualine_a = { { 'filename' } },
        -- lualine_b = { { nv.icons.fticon() } },
        -- lualine_c = { { nv.icons.fticon() } },
        lualine_x = { 'mode' },
        lualine_y = { { nv.icons.fticon } },
        -- lualine_z = { { nv.icons.fticon() } },
      },
    }
    return opts
  end,
}
