local M = {}

--- @type string[] The list of LSP servers to configure and enable from `lsp/`
M.servers = vim.tbl_map(function(path)
  return path:match('^.+/(.+)$'):sub(1, -5)
end, vim.fn.globpath(vim.fn.stdpath('config') .. '/after/lsp', '*', true, true))

return setmetatable(M, {
  __index = function(t, k)
    t[k] = require('nvim.util.lsp.' .. k)
    return t[k]
  end,
})
