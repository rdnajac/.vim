local lib = require('nvim-navic.lib')

local opts = {
  depth_limit = 0,
  depth_limit_indicator = ' ',
  separator = '',
}

local M = {}

M.is_available = function(bufnr)
  return vim.b[bufnr or vim.api.nvim_get_current_buf()].navic_client_id ~= nil
end

---@param bufnr number
---@return string
function M.get(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  if not M.is_available(bufnr) then
    return ''
  end

  local ctx = lib.get_context_data(bufnr)
  if type(ctx) ~= 'table' or vim.tbl_isempty(ctx) then
    return ''
  end

  local items = vim
    .iter(vim.list_slice(ctx, 2))
    :map(function(v)
      local kind = v.kind
      local icon = nv.icons.kinds[kind]
      if type(icon) ~= 'string' then
        icon = ''
      end
      local name = v.name
      if type(name) ~= 'string' then
        name = ''
      end
      name = name:gsub('%%', '%%%%'):gsub('\n', ' ')
      return icon .. name
    end)
    :totable()

  if #items == 0 then
    return ''
  end

  if opts.depth_limit > 0 and #items > opts.depth_limit then
    items = vim.list_slice(items, #items - opts.depth_limit + 1, #items)
    table.insert(items, 1, opts.depth_limit_indicator)
  end

  return table.concat(items, opts.separator or ' ')
end

return M
