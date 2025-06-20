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
  lualine_b = { 
    {
      require('lazy.spec.lualine.components.navic'),
      -- color_correction = 'dynamic',
      -- navic_opts = {
        --   -- depth_limit = 9,
        --   depth_limit_indicator = LazyVim.config.icons.misc.dots,
        --   highlight = false, -- must be false for color to apply
        --   icons = LazyVim.config.icons.kinds,
        --   lazy_update_context = false,
        --   separator = ' ',
        -- },
        color = { bg = 'NONE' },
      }
  },
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
      cond = function()
        return vim.bo.bufhidden ~= 'wipe'
      end,
    },
    {
      'filename',
      separator = { right = '🭛' },
      cond = function()
        return vim.bo.bufhidden ~= 'wipe'
      end,
    },
  },
  lualine_z = { date },
}

return M
