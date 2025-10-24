local M = {}

---@type string[] The list of LSP servers to configure and enable from `lsp/`
M.servers = vim.tbl_map(function(path)
  return path:match('^.+/(.+)$'):sub(1, -5)
end, vim.fn.globpath(vim.fs.joinpath(vim.g.stdpath.config, 'after', 'lsp'), '*.lua', false, true))

M.attached = function(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local clients = vim.tbl_map(function(c)
    return c.name
  end, vim.lsp.get_clients({ bufnr = buf }))
  clients = vim.tbl_filter(function(name)
    return name ~= 'copilot'
  end, clients)
  return table.concat(clients, ';')
end

return setmetatable(M, {
  __index = function(t, k)
    t[k] = require('nvim.util.lsp.' .. k)
    return t[k]
  end,
})
