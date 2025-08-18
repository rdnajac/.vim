-- https://github.com/SmiteshP/nvim-navic
local lib = require('vimline.docsymbols.navic_lib')

local awaiting_lsp_response = {}
local function lsp_callback(for_buf, symbols)
  awaiting_lsp_response[for_buf] = false
  lib.update_data(for_buf, symbols)
end

local aug = vim.api.nvim_create_augroup('navic', { clear = false })

-- Attach to the given buffer if the client supports document symbols
---@param client vim.lsp.Client | nil
---@param bufnr number
local attach = function(client, bufnr)
  -- if not client.server_capabilities.documentSymbolProvider then
  if not client or not client:supports_method('textDocument/documentSymbol') then
    return
  end

  if vim.b[bufnr].navic_client_id ~= nil and vim.b[bufnr].navic_client_name ~= client.name then
    return
  end

  vim.b[bufnr].navic_client_id = client.id
  vim.b[bufnr].navic_client_name = client.name
  local changedtick = 0

  vim.api.nvim_clear_autocmds({
    buffer = bufnr,
    group = aug,
  })

  vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufEnter', 'CursorHold' }, {
    callback = function()
      if not awaiting_lsp_response[bufnr] and changedtick < vim.b[bufnr].changedtick then
        awaiting_lsp_response[bufnr] = true
        changedtick = vim.b[bufnr].changedtick
        lib.request_symbol(bufnr, lsp_callback, client)
      end
    end,
    group = aug,
    buffer = bufnr,
  })

  vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorMoved' }, {
    callback = function()
      lib.update_context(bufnr)
    end,
    group = aug,
    buffer = bufnr,
  })

  vim.api.nvim_create_autocmd('BufDelete', {
    callback = function()
      lib.clear_buffer_data(bufnr)
    end,
    group = aug,
    buffer = bufnr,
  })

  -- First call
  vim.b[bufnr].navic_awaiting_lsp_response = true
  lib.request_symbol(bufnr, lsp_callback, client)
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = aug,
  callback = function(ev)
    attach(vim.lsp.get_client_by_id(ev.data.client_id), ev.buf)
  end,
})
