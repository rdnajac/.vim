local M = {}

M.spec = vim.tbl_map(function(plugin)
  return {
    'folke/' .. plugin .. '.nvim',
    config = function() require('folke.' .. plugin) end,
  }
end, { 'snacks', 'tokyonight', 'which-key' })

return M
