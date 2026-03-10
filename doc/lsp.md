# lsp

## unused configs

clangd

```lua
return {
  cmd = {
    'clangd',
    '--background-index',
    '--clang-tidy',
    -- '--header-insertion=iwyu',
    -- '--completion-style=detailed',
    -- '--function-arg-placeholders',
    -- '--fallback-style=llvm',
  },
  -- init_options = {
  --   usePlaceholders = true,
  --   completeUnimported = true,
  --   clangdFileStatus = true,
  -- },
}
```

rlanguageserver

```lua
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.completion.completionItem = nil -- disables LSP completion

--- @type vim.lsp.Config
return {
  -- BUG: renv errors routed to rpc as INVALID_SERVER_MESSAGE
  -- cmd = { 'r-languageserver' }, -- launcher script from mason installation
  cmd = vim.split([[R --vanilla --quiet --no-echo --no-save -e "languageserver::run()"]], ' '),
  filetypes = { 'r', 'rmd', 'quarto' },
  root_markers = { '.Rprofile', '.git' },
  -- capabilities = capabilities,
}
```
