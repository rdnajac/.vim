local M = {}

M.keymaps = function(bufnr)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })

  -- stylua: ignore
  require('which-key').add({
    -- icon = { icon = ' ', color = 'orange' },
    -- { 'gO' },
    -- { 'gr', group = 'LSP' },
    { 'grr', function() Snacks.picker.lsp_references() end, desc = 'References', buffer = bufnr, nowait = true, },
    { 'gd',  function() Snacks.picker.lsp_definitions() end,       desc = 'Goto Definition', buffer = bufnr },
    { 'gD',  function() Snacks.picker.lsp_declarations() end,      desc = 'Goto Declaration', buffer = bufnr },
    { 'gri', function() Snacks.picker.lsp_implementations() end,   desc = 'Goto Implementation', buffer = bufnr },
    { 'gry', function() Snacks.picker.lsp_type_definitions() end,  desc = 'Goto T[y]pe Definition', buffer = bufnr },
    { 'grs', function() Snacks.picker.lsp_symbols() end,           desc = 'LSP Symbols', buffer = bufnr },
    { 'grw', function() Snacks.picker.lsp_workspace_symbols() end, desc = 'LSP Workspace Symbols', buffer = bufnr },
  })
end

---@param client vim.lsp.Client
---@param bufnr integer
M.on_attach = function(client, bufnr)
  M.keymaps()
  client.server_capabilities.documentFormattingProvider = false
  -- client.server_capabilities.semanticTokensProvider = nil
  if client:supports_method('textDocument/inlayHint') then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    Snacks.toggle.inlay_hints():map('<leader>uh')
  end
  if client:supports_method('textDocument/codeLens') then
    vim.lsp.codelens.refresh()
    vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
      buffer = bufnr,
      callback = vim.lsp.codelens.refresh,
    })
  end

  -- requires plugin
  -- if client:supports_method('textDocument/documentSymbol') then
  --   require('util.lualine.docsymbols').attach(client, bufnr)
  -- end
end

-- Refer to `:h vim.lsp.config()` for more information.
vim.lsp.config('*', {
  -- capabilities = require('blink.cmp').get_lsp_capabilities(),
  on_attach = M.on_attach,
})

-- vim.lsp.enable(_G.lang_spec.lsps)
vim.lsp.enable({
  -- 'ruff',
  'luals',
  'vimls',
  -- 'bashls',
})

return M
