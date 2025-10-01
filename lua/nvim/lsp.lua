local M = {}

M.name = 'lsp'

-- TODO: check whether the configs in after/lsp actually override the default configs
M.specs = {
  -- 'neovim/nvim-lspconfig',
  -- 'b0o/SchemaStore.nvim',
}

---@type string[] The list of LSP servers to configure and enable from `lsp/`
M.servers = vim.tbl_map(function(path)
  return path:match('^.+/(.+)%.lua$')
end, vim.api.nvim_get_runtime_file('lsp/*.lua', true))

M.config = function()
  --- servers won't start on restart, so schedule it
  vim.schedule(function()
    vim.lsp.config('*', { on_attach = require('nvim.lsp.on_attach') })
    vim.lsp.enable(M.servers)
  end)
  require('nvim.lsp.progress')
  -- require('nvim.lsp.completion')
  nv.util.lazyload(function()
    require('nvim.lsp.lazydev').config()
  end, 'FileType', 'lua')
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
  local names = vim.tbl_map(function(c) return c.name end, clients)
  return ("%s%s%s"):format(
    #clients == 0 and nv.icons.lsp.unavailable or "",
    (#clients > 0 and not (#clients == 1 and vim.tbl_contains(names, "copilot")))
      and nv.icons.lsp.attached or "",
    vim.tbl_contains(names, "copilot") and nv.icons.src.copilot or ""
  )
end

M.docsymbols = function()
  return require('nvim.lsp.docsymbols').get()
end

return M
