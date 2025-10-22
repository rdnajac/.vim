local lib = require('nvim-navic.lib')
local opts = {
  depth_limit = 0,
  depth_limit_indicator = ' ',
  separator = ' ',
}
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
--- @return string docsymbols statusline component
function M.get(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local data = M.get_data(bufnr)
  local iter = vim.iter(data)
  return iter
    -- WARN: unsafe?
    :map(function(v)
      -- local kind = v.kind ---@type number
      -- uses reverse lookup
      -- local icon = nv.icons.kinds[kind]
      local icon = nv.icons.kinds[v.kind]
      local name = v.name:gsub('%%', '%%%%')
      -- if type(icon) ~= 'string' then icon = '' end
      -- if type(name) ~= 'string' then name = '' end
      return icon .. name
    end)
    :join(opts.separator)
end

local aug = vim.api.nvim_create_augroup('navic', { clear = false })

-- Attach to the given buffer if the client supports document symbols
---@param client vim.lsp.Client|nil
---@param bufnr number
M.attach = function(client, bufnr)
  if
    not client
    or not client:supports_method('textDocument/documentSymbol')
    or (vim.b[bufnr].navic_client_id and vim.b[bufnr].navic_client_name ~= client.name)
  then
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

return setmetatable(M, {
  __call = function(_, ...)
    return M.get(...)
  end,
})
