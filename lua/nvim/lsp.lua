local M = { 'neovim/nvim-lspconfig' }

M.specs = {
  -- 'b0o/SchemaStore.nvim',
}

--- @type string[] The list of LSP servers to configure and enable from `lsp/`
M.servers = vim.tbl_map(function(path)
  return path:match('^.+/(.+)$'):sub(1, -5)
end, vim.fn.globpath(vim.fn.stdpath('config') .. '/after/lsp', '*', true, true))

M.config = function()
  -- TODO: just make sure we schedule the whole config...
  --- servers don't start on restart, so schedule it
  vim.schedule(function()
    vim.lsp.config('*', { on_attach = require('nvim.lsp.on_attach') })
    vim.lsp.enable(M.servers)
  end)
  require('nvim.lsp.progress')
  -- require('nvim.lsp.completion')
end

-- FIXME: this sucks
M.root = function(path)
  path = path or vim.api.nvim_buf_get_name(0)
  if path == '' then
    return nil
  end
  path = vim.uv.fs_realpath(path) or path

  local best
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    if client.root_dir and path:find(client.root_dir, 1, true) == 1 then
      if not best or #client.root_dir > #best then
        best = client.root_dir
      end
    end
  end
  if best then
    return best
  end

  local markers = {}
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    local m = client.config and client.config.root_markers
    if m then
      vim.list_extend(markers, m)
    end
  end
  if #markers > 0 then
    return vim.fs.root(path, markers)
  end
  return vim.fs.root(path, { '.git' })
end

-- FIXME: this sucks
M.status = function()
  local clients = vim.lsp.get_clients()
  if #clients == 0 then
    return nv.icons.lsp.unavailable
  end
  local names = vim.tbl_map(function(c)
    return c.name
  end, clients)
  return ('%s%s'):format(
    (not (#clients == 1 and vim.tbl_contains(names, 'copilot'))) and nv.icons.lsp.attached,
    vim.tbl_contains(names, 'copilot') and nv.icons.src.copilot or ' '
  )
end

M.docsymbols = function()
  return require('nvim.lsp.docsymbols').get()
end

return M
