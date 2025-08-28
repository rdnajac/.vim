local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem = nil  -- disables LSP completion

--- @type vim.lsp.Config
return {
  cmd = { 'r-languageserver' }, -- launcher script from mason installation
  -- cmd = {
  --   'R',
  --   '--vanilla',
  --   '--quiet',
  --   '--no-echo',
  --   '--no-save',
  --   '-e',
  --   'languageserver::run()',
  -- },
  filetypes = { 'r', 'rmd', 'quarto' },
  root_markers = { '.Rprofile', '.git' },
  capabilities = capabilities,
}
