local M = { 'mfussenegger/nvim-lint' }

M.opts = {}

M.config = function()
  require('nvim-lint').setup(M.opts)
end

return M
