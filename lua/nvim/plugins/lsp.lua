local M = {}

M.specs = {
  'neovim/nvim-lspconfig',
  -- 'b0o/SchemaStore.nvim',
  'SmiteshP/nvim-navic',
}

--- @type string[] The list of LSP servers to configure and enable from `lsp/`
M.servers = vim.tbl_map(function(path)
  return path:match('^.+/(.+)$'):sub(1, -5)
end, vim.fn.globpath(vim.fn.stdpath('config') .. '/after/lsp', '*', true, true))

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
  if #clients > 0 then
    local names = vim.tbl_map(function(c)
      return c.name
    end, clients)
    if not (#clients == 1 and vim.tbl_contains(names, 'copilot')) then
      return nv.icons.lsp.attached
    end
  end
  return nv.icons.lsp.unavailable
end

M.docsymbols = function()
  return require('nvim.plugins.lsp.docsymbols').get()
end

--- `blink.cmp` will automatically set some capabilities:
--- `capabilities = require('blink.cmp').get_lsp_capabilities()`,
--- see `vim.lsp.protocol.make_client_capabilities()` for nvim's defaults
---
--- @param client vim.lsp.Client
--- @param bufnr integer
local on_attach = function(client, bufnr)
  -- set this manually in case there is another mapping for `K`
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })

  -- client.server_capabilities.documentFormattingProvider = false
  -- client.server_capabilities.semanticTokensProvider = nil
  if client:supports_method('textDocument/inlayHint') then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end

  if client:supports_method('textDocument/codeLens') then
    vim.lsp.codelens.refresh()
    vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
      buffer = bufnr,
      callback = vim.lsp.codelens.refresh,
    })
  end
  -- if client:supports_method('textDocument/documentSymbol') then
  require('nvim.plugins.lsp.docsymbols.navic_attach')(client, bufnr)
  -- TODO: inline completion?
end
vim.schedule(function()
  vim.lsp.config('*', { on_attach = on_attach })
  vim.lsp.enable(M.servers)
  require('nvim.plugins.lsp.progress')
end)

return M
