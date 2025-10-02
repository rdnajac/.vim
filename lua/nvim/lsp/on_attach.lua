--- Apply keymaps and other settings when LSP attaches to a buffer
---
--- lsp default keymaps: no longer need to be set manually
--- `gra` mode = {'n', 'v'} `vim.lsp.buf.code_action()`
--- `gri` mode = 'n' `vim.lsp.buf.implementation()`
--- `grn` mode = 'n' `vim.lsp.buf.rename()`
--- `grr` mode = 'n' `vim.lsp.buf.references()`
--- `grt` mode = 'n' `vim.lsp.buf.type_definition()`
--- `gO`  mode = 'n' `vim.lsp.buf.document_symbol()`
--- `<CTRL-S>` mode = 'i' `vim.lsp.buf.signature_help()` -- TODO: see blink.cmp
--- `an`, `in` mode = 'v' inner/outer `vim.lsp.buf.selection_range()`
---
--- `blink.cmp` will automatically set some capabilities
--- to customize further, uncomment this line and pass your own capabilities
--- capabilities = require('blink.cmp').get_lsp_capabilities(),
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
  require('nvim.lsp.docsymbols.navic_attach')(client, bufnr)
  -- TODO: inline completion?
end

return on_attach
