local M = {}

-- TODO: check whether the configs in after/lsp actually override the default configs
M.specs = {
  -- 'neovim/nvim-lspconfig',
  'b0o/SchemaStore.nvim',
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
  nv.lazyload(function()
    require('nvim.lsp.lazydev').config()
  end, 'FileType', 'lua')
end

---Find project root using LSP config root_markers for the buffer's filetype.
---@param path? string starting path (defaults to current buffer path)
---@return string|nil
M.root = function(path)
  -- if no path given, use the current buffer path
  if not path or path == '' then
    path = vim.api.nvim_buf_get_name(0)
  end
  if path == '' then
    return nil
  end

  -- TODO: maybe we need lspconfig to get the ft mapping?
  -- maybe mason has it?
  local cgf = vim.lsp.config[vim.bo.filetype] --- XXX: BAD!
  if not cgf or not cgf.root_markers then
    return nil
  end

  return vim.fs.root(path, lsp_cfg.root_markers)
end

M.status = function()
  for _, client in pairs(vim.lsp.get_clients()) do
    if client.name ~= 'copilot' then
      return nv.icons.lsp.attached
    end
  end
  return nv.icons.lsp.unavailable .. ' '
end

M.docsymbols = function()
  return require('nvim.lsp.docsymbols').get()
end

return M
