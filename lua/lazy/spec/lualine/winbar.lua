local M = {}
local date = require('lazy.spec.lualine.components.time').date
M.active = {
  lualine_a = {
    {
      'diagnostics',
      symbols = LazyVim.config.icons.diagnostics,
      always_visible = true,
      color = { bg = '#3b4261' },
      -- separator = { right = '🭛' },
      -- cond = function()
      --   local ft = vim.bo.filetype
      --   return ft ~= 'snacks_terminal' and ft ~= 'oil'
      -- end,
    },
  },
  lualine_b = { require('lazy.spec.lualine.components.navic') },
  lualine_z = { date },
}

M.inactive = {
  lualine_a = {
    {
      function()
        local icon = ''
        local ok, devicons = pcall(require, 'nvim-web-devicons')
        if ok then
          icon = devicons.get_icon(vim.fn.expand('%:t'), nil, { default = true })
            or devicons.get_icon_by_filetype(vim.bo.filetype, { default = true })
            or ''
        end
        return icon
      end,
    },
    { 'filename', separator = { right = '🭛' } },
  },
  lualine_z = { date },
}

return M
