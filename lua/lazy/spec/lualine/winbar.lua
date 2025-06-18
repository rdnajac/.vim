local M = {}

local date = {
  function()
    return ' ' .. os.date('%F')
  end,
  color = { gui = 'reverse,bold' },
  cond = function()
    return vim.fn.win_id2win(vim.api.nvim_get_current_win()) == 1
  end,
}

M.active = {
  -- { 'branch', separator = { right = '🭛' } },
  lualine_b = {
    require('lazy.spec.lualine.components.navic'),
  },
  lualine_z = { date },
}

M.inactive = {
  lualine_a = {
    {
      'filename',
      separator = { right = '🭛' },
    },
  },
  lualine_z = { date },
}
return M
