local icons = nv.icons

return {
  'nvim-lualine/lualine.nvim',
  enabled = true,
  opts = function()
    -- PERF: we don't need this lualine require madness 🤷
    local lualine_require = require('lualine_require')
    lualine_require.require = require

    local opts = {
      options = {
        theme = 'auto',
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
      extensions = {},
    }
    return opts
  end,
}
