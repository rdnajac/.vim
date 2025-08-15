-- https://github.com/SmiteshP/nvim-navic
local lib = require('vimline.docsymbols.navic_lib')

local awaiting_lsp_response = {}
local function lsp_callback(for_buf, symbols)
  awaiting_lsp_response[for_buf] = false
  lib.update_data(for_buf, symbols)
end

-- Attach to the given buffer if the client supports document symbols
local M = function(client, bufnr)
  if not client.server_capabilities.documentSymbolProvider then
    return
  end

  if vim.b[bufnr].navic_client_id ~= nil and vim.b[bufnr].navic_client_name ~= client.name then
    return
  end

  vim.b[bufnr].navic_client_id = client.id
  vim.b[bufnr].navic_client_name = client.name
  local changedtick = 0

  local navic_augroup = vim.api.nvim_create_augroup('navic', { clear = false })
  vim.api.nvim_clear_autocmds({
    buffer = bufnr,
    group = navic_augroup,
  })

  vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufEnter', 'CursorHold' }, {
    callback = function()
      if not awaiting_lsp_response[bufnr] and changedtick < vim.b[bufnr].changedtick then
        awaiting_lsp_response[bufnr] = true
        changedtick = vim.b[bufnr].changedtick
        lib.request_symbol(bufnr, lsp_callback, client)
      end
    end,
    group = navic_augroup,
    buffer = bufnr,
  })

  vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorMoved' }, {
    callback = function()
      lib.update_context(bufnr)
    end,
    group = navic_augroup,
    buffer = bufnr,
  })

  vim.api.nvim_create_autocmd('BufDelete', {
    callback = function()
      lib.clear_buffer_data(bufnr)
    end,
    group = navic_augroup,
    buffer = bufnr,
  })

  -- First call
  vim.b[bufnr].navic_awaiting_lsp_response = true
  lib.request_symbol(bufnr, lsp_callback, client)
end

return M
