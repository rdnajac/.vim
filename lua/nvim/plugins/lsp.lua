local M = {}

M.specs = {
  'neovim/nvim-lspconfig',
  'SmiteshP/nvim-navic',
  -- 'b0o/SchemaStore.nvim',
}

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

  nv.lsp.docsymbols.attach(client, bufnr)
end

M.config = function()
  vim.schedule(function()
    vim.lsp.config('*', { on_attach = on_attach })
    vim.lsp.enable(nv.lsp.servers)
    -- require('nvim.plugins.lsp.progress')
  end)
end

return M
