local M = {}

---@return string The LSP status indicator for the statusline
M.status = function()
  local clients = vim.lsp.get_clients()
  if #clients > 0 then
    local names = vim.tbl_map(function(c)
      return c.name
    end, clients)
    if not (#clients == 1 and vim.tbl_contains(names, 'copilot')) then
      return nv.icons.lsp.attached
    end
  end
  return nv.icons.lsp.unavailable .. ' '
end

---@type string[] The list of LSP servers to configure and enable from `lsp/`
M.servers = vim.tbl_map(function(path)
  return path:match('^.+/(.+)$'):sub(1, -5)
end, vim.fn.globpath(vim.fn.stdpath('config') .. '/after/lsp', '*', true, true))

return setmetatable(M, {
  __index = function(t, k)
    t[k] = require('nvim.util.lsp.' .. k)
    return t[k]
  end,
})
