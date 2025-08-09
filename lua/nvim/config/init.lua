-- automagically load plugin modules in this directory
local M = vim.defer_fn(function()
  require('meta.module')()
end, 0)

return M
