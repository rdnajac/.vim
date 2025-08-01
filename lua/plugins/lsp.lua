-- local M = { 'neovim/nvim-lspconfig' }
local M = {}

-- lsp defaults
-- `grn` is mapped in Normal mode to `vim.lsp.buf.rename()`
-- `gra` is mapped in Normal and Visual mode to `vim.lsp.buf.code_action()`
-- `grr` is mapped in Normal mode to `vim.lsp.buf.references()`
-- `gri` is mapped in Normal mode to `vim.lsp.buf.implementation()`
-- `grt` is mapped in Normal mode to `vim.lsp.buf.type_definition()`
-- `gO` is mapped in Normal mode to `vim.lsp.buf.document_symbol()`
-- `<CTRL-S>` is mapped in Insert mode to `vim.lsp.buf.signature_help()`
-- `an` and `in` are mapped in Visual mode to outer and inner incremental
-- selections, respectively, using |vim.lsp.buf.selection_range()|

-- override some of the default LSP keymaps with snacks
M.keys = function()
  local opts = { buffer = true, nowait = true }
  -- stylua: ignore
  return {
    { 'grr', function() Snacks.picker.lsp_references() end,        opts },
    { 'gd',  function() Snacks.picker.lsp_definitions() end,       opts },
    { 'gD',  function() Snacks.picker.lsp_declarations() end,      opts },
    { 'gri', function() Snacks.picker.lsp_implementations() end,   opts },
    { 'gry', function() Snacks.picker.lsp_type_definitions() end,  opts },
    { 'grs', function() Snacks.picker.lsp_symbols() end,           opts },
    { 'grw', function() Snacks.picker.lsp_workspace_symbols() end, opts },
  }
end

---@param client vim.lsp.Client
---@param bufnr integer
M.on_attach = function(client, bufnr)
  -- set this manually in case there is another mapping for `K`
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = true })

  -- set the rest of the keymaps
  for _, keymap in ipairs(M.keys()) do
    vim.keymap.set('n', keymap[1], keymap[2], keymap.opts)
  end

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

M.config = function()
  -- Refer to `:h vim.lsp.config()` for more information.
  -- `blink.cmp` will automatically set the capabilities
  vim.lsp.config('*', {
    -- capabilities = require('blink.cmp').get_lsp_capabilities(),
    on_attach = M.on_attach,
  })

  vim.lsp.enable({
    'bashls',
    'luals',
    'ruff',
    'vimls',
  })
end

return M
