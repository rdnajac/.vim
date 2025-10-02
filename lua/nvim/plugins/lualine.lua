return {
  'nvim-lualine/lualine.nvim',
  enabled = true,
  opts = {
    options = {
      theme = 'auto',
      section_separators = { left = '', right = '' },
      component_separators = { left = '', right = '' },
      globalstatus = false, -- don’t hijack the statusline
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
    extensions = {},
  },
}
