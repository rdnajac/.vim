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

  if client:supports_method('textDocument/codeLens') then
    vim.lsp.codelens.refresh()
    vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
      buffer = bufnr,
      callback = vim.lsp.codelens.refresh,
    })
  end

  -- if client:supports_method('textDocument/documentSymbol') then
  --   nv.lsp.docsymbols.attach(client, bufnr)
  -- end

  if client:supports_method('textDocument/inlayHint') then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end
end

vim.lsp.config('*', opts)

local M = {}

---@type string[] The list of LSP servers to configure and enable from `lsp/`
M.servers = vim.tbl_map(function(path)
  return path:match('^.+/(.+)$'):sub(1, -5)
end, vim.fn.globpath(vim.fs.joinpath(vim.g.stdpath.config, 'after', 'lsp'), '*.lua', false, true))

vim.lsp.enable(M.servers)

M.attached = function(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local clients = vim.tbl_map(function(c)
    return c.name
  end, vim.lsp.get_clients({ bufnr = buf }))
  clients = vim.tbl_filter(function(name)
    return name ~= 'copilot'
  end, clients)
  return table.concat(clients, ';')
end

return setmetatable(M, {
  __index = function(t, k)
    t[k] = require('nvim.lsp.' .. k)
    return t[k]
  end,
})
