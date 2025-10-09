--- @type vim.lsp.Config
local opts = {}

--- `blink.cmp` will automatically set some capabilities:
--- `capabilities = require('blink.cmp').get_lsp_capabilities()`,
--- see `vim.lsp.protocol.make_client_capabilities()` for nvim's defaults

--- @param client vim.lsp.Client
--- @param bufnr integer
opts.on_attach = function(client, bufnr)
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

return {
  opts = opts,
  setup = function()
    vim.lsp.config('*', opts)
    vim.lsp.enable(nv.lsp.servers)
    nv.lsp.progress.setup()
  end,
}
