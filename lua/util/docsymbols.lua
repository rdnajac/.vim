local lib = require('util.naviclib')
local icons = require('util.icons')

local M = {}

local config = {
  icons = icons.kinds,
  depth_limit = 0,
  depth_limit_indicator = icons.misc.dots,
  lazy_update_context = false,
  separator = ' ',
}

setmetatable(config.icons, {
  __index = function()
    return '? '
  end,
})

for k, v in pairs(config.icons) do
  if lib.adapt_lsp_str_to_num(k) then
    config.icons[lib.adapt_lsp_str_to_num(k)] = v
  end
end

function M.is_available(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  return vim.b[bufnr].navic_client_id ~= nil
end

-- returns table of context or nil
function M.get_data(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local context_data = lib.get_context_data(bufnr)

  if context_data == nil then
    return nil
  end

  local ret = {}

  for i, v in ipairs(context_data) do
    if i ~= 1 then
      table.insert(ret, {
        kind = v.kind,
        type = lib.adapt_lsp_num_to_str(v.kind),
        name = v.name,
        icon = config.icons[v.kind],
        scope = v.scope,
      })
    end
  end

  return ret
end

local function sanitize_name(v)
  local name = v.name and v.name or ''
  name = string.gsub(name, '%%', '%%%%')
  name = string.gsub(name, '\n', ' ')
  return name
end

function M.format_data(data, opts)
  if not data then
    return ''
  end

  local location = vim.tbl_map(function(v)
    return v.icon .. sanitize_name(v)
  end, data)

  if config.depth_limit > 0 and #location > config.depth_limit then
    location = vim.list_slice(location, #location - config.depth_limit + 1, #location)
    table.insert(location, 1, config.depth_limit_indicator)
  end

  return table.concat(location, config.separator)
end

function M.get_location(opts, bufnr)
  local data = M.get_data(bufnr)
  return M.format_data(data, opts)
end

local awaiting_lsp_response = {}
local function lsp_callback(for_buf, symbols)
  awaiting_lsp_response[for_buf] = false
  lib.update_data(for_buf, symbols)
end

function M.attach(client, bufnr)
  if not client.server_capabilities.documentSymbolProvider then
    if not vim.g.navic_silence then
      vim.notify('nvim-navic: Server "' .. client.name .. '" does not support documentSymbols.', vim.log.levels.ERROR)
    end
    return
  end

  if vim.b[bufnr].navic_client_id ~= nil and vim.b[bufnr].navic_client_name ~= client.name then
    local prev_client = vim.b[bufnr].navic_client_name
    if not vim.g.navic_silence then
      vim.notify(
        'nvim-navic: Failed to attach to ' .. client.name .. ' for current buffer. Already attached to ' .. prev_client,
        vim.log.levels.WARN
      )
    end
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
  vim.api.nvim_create_autocmd('CursorHold', {
    callback = function()
      lib.update_context(bufnr)
    end,
    group = navic_augroup,
    buffer = bufnr,
  })
  if not config.lazy_update_context then
    vim.api.nvim_create_autocmd('CursorMoved', {
      callback = function()
        if vim.b.navic_lazy_update_context ~= true then
          lib.update_context(bufnr)
        end
      end,
      group = navic_augroup,
      buffer = bufnr,
    })
  end
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
