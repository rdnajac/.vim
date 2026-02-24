local lib = require('nvim-navic.lib')

local awaiting_lsp_response = {}
local function lsp_callback(for_buf, symbols)
  awaiting_lsp_response[for_buf] = false
  lib.update_data(for_buf, symbols)
end

local M = {}

---@param bufnr? number defaults to current buffer
---@return table
function M.get_data(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if not vim.b[bufnr].navic_client_id then
    return {}
  end
  local context_data = lib.get_context_data(bufnr)
  return context_data and vim.list_slice(context_data or {}, 2) or {}
end

--- @param bufnr? number defaults to current buffer
function M.get(bufnr)
  local data = M.get_data(bufnr)
  return vim.tbl_map(function(v)
    local icon = require('nvim.ui.icons').kinds[v.kind]
    return icon .. v.name:gsub('%%', '%%%%')
  end, data)
end

local aug = vim.api.nvim_create_augroup('navic', { clear = false })

-- Attach to the given buffer if the client supports document symbols
---@param client vim.lsp.Client
---@param bufnr? number
M.attach = function(client, bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  if vim.b[bufnr].navic_client_id and vim.b[bufnr].navic_client_name ~= client.name then
    return -- already attached to another client
  end

  vim.b[bufnr].navic_client_id = client.id
  vim.b[bufnr].navic_client_name = client.name
  local changedtick = 0

  vim.api.nvim_clear_autocmds({ buffer = bufnr, group = aug })

  local au = function(events, cb)
    vim.api.nvim_create_autocmd(events, { callback = cb, group = aug, buffer = bufnr })
  end

  au({ 'InsertLeave', 'BufEnter', 'CursorHold' }, function()
    if not awaiting_lsp_response[bufnr] and changedtick < vim.b[bufnr].changedtick then
      awaiting_lsp_response[bufnr] = true
      changedtick = vim.b[bufnr].changedtick
      lib.request_symbol(bufnr, lsp_callback, client)
    end
  end)
  au({ 'CursorHold', 'CursorMoved' }, function() lib.update_context(bufnr) end)
  au('BufDelete', function() lib.clear_buffer_data(bufnr) end)

  -- First call
  vim.b[bufnr].navic_awaiting_lsp_response = true
  lib.request_symbol(bufnr, lsp_callback, client)
end

return setmetatable(M, {
  __call = function(_, ...) return M.get(...) end,
})
