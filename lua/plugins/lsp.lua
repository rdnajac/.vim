local M = {}

M.dependencies = {
  'b0o/SchemaStore.nvim',
}

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
  -- TODO use which key to set these up
  -- stylua: ignore
  return {
    { 'glr', function() Snacks.picker.lsp_references() end,        opts },
    { 'gld', function() Snacks.picker.lsp_definitions() end,       opts },
    { 'glD', function() Snacks.picker.lsp_declarations() end,      opts },
    { 'gli', function() Snacks.picker.lsp_implementations() end,   opts },
    { 'glt', function() Snacks.picker.lsp_type_definitions() end,  opts },
    { 'gls', function() Snacks.picker.lsp_symbols() end,           opts },
    { 'glw', function() Snacks.picker.lsp_workspace_symbols() end, opts },
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

  -- see `:h lsp-inlay_hint`
  if client:supports_method('textDocument/inlayHint') then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    Snacks.toggle.inlay_hints():map('<leader>uh')
  end

  -- see `:h lsp-codelens`
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
  --   vim.api.nvim_create_autocmd('LspProgress', {
  --     callback = function(ev)
  --       local value = ev.data.params.value
  --       if value.kind == 'begin' then
  --         io.stdout:write('\027]9;4;1;0\027\\')
  --       elseif value.kind == 'end' then
  --         io.stdout:write('\027]9;4;0\027\\')
  --       elseif value.kind == 'report' then
  --         io.stdout:write(string.format('\027]9;4;1;%d\027\\', value.percentage))
  --       end
  --     end,
  --   })

  vim.lsp.config('*', {
    on_attach = M.on_attach,
    -- `blink.cmp` will automatically set some capabilities
    -- capabilities = require('blink.cmp').get_lsp_capabilities(),
  })

  local servers = vim.tbl_map(function(path)
    return path:match('^.+/(.+)%.lua$')
  end, vim.api.nvim_get_runtime_file('lsp/*.lua', true))

  vim.lsp.enable(servers)
end

return M
