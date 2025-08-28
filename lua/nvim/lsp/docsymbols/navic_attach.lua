-- https://github.com/SmiteshP/nvim-navic
local lib = require('nvim.lsp.docsymbols.navic_lib')

local awaiting_lsp_response = {}
local function lsp_callback(for_buf, symbols)
  awaiting_lsp_response[for_buf] = false
  lib.update_data(for_buf, symbols)
end

local aug = vim.api.nvim_create_augroup('navic', { clear = false })

-- Attach to the given buffer if the client supports document symbols
---@param client vim.lsp.Client | nil
---@param bufnr number
local M = function(client, bufnr)
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

  local au = function(events, cb)
    vim.api.nvim_create_autocmd(events, {
      callback = cb,
      group = aug,
      buffer = bufnr,
    })
  end

  au({ 'InsertLeave', 'BufEnter', 'CursorHold' }, function()
    if not awaiting_lsp_response[bufnr] and changedtick < vim.b[bufnr].changedtick then
      awaiting_lsp_response[bufnr] = true
      changedtick = vim.b[bufnr].changedtick
      lib.request_symbol(bufnr, lsp_callback, client)
    end
  end)

  au({ 'CursorHold', 'CursorMoved' }, function()
    lib.update_context(bufnr)
  end)

  au('BufDelete', function()
    lib.clear_buffer_data(bufnr)
  end)

  -- First call
  vim.b[bufnr].navic_awaiting_lsp_response = true
  lib.request_symbol(bufnr, lsp_callback, client)
end

return M
