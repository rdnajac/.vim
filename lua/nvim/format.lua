local M = { 'stevearc/conform.nvim' }

M.opts = {}

M.config = function()
  require('conform').setup(M.opts)
end

return M
