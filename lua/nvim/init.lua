local M =  vim.defaulttable(function(k)
  return require('nvim.' .. k)
end)

_G.nvim = M

return M
