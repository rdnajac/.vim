local icons = nv.icons
local lib = require('nvim.lsp.docsymbols.navic_lib')

local config = {
  icons = icons.kinds,
  depth_limit = 0,
  depth_limit_indicator = icons.misc.dots,
  separator = '',
  hl = {
    icon = 'Constant',
    text = 'Chromatophore_y',
    sep = 'Constant',
  },
}

local M = {}

M.is_available = function(bufnr)
  return vim.b[bufnr or vim.api.nvim_get_current_buf()].navic_client_id ~= nil
end

-- returns table of context or nil
---@param bufnr number
---@return table|nil
function M.get_data(bufnr)
  local context_data = lib.get_context_data(bufnr)
  local ret = {}

  if context_data then
    for i, v in ipairs(context_data) do
      if i ~= 1 then
        table.insert(ret, {
          kind = v.kind,
          type = vim.lsp.protocol.SymbolKind[v.kind] or 'Text',
          name = v.name,
          icon = config.icons[v.kind],
          scope = v.scope,
        })
      end
    end
  end
  return ret
end

---@param data table
---@param apply_hl? boolean
---@return string
function M.format_data(data, apply_hl)
  apply_hl = apply_hl or false

  local function maybe_hl(hl, text)
    return apply_hl and ('%#' .. hl .. '#' .. text) or text
  end

  local function sanitize_name(v)
    local name = v.name or ''
    name = name:gsub('%%', '%%%%')
    name = name:gsub('\n', ' ')
    return name
  end

  local location = vim.tbl_map(function(v)
    return maybe_hl(config.hl.icon, v.icon) .. maybe_hl(config.hl.text, sanitize_name(v))
  end, data)

  if config.depth_limit > 0 and #location > config.depth_limit then
    location = vim.list_slice(location, #location - config.depth_limit + 1, #location)
    table.insert(location, 1, maybe_hl(config.hl.icon, config.depth_limit_indicator))
  end

  local sep = maybe_hl(config.hl.sep, config.separator)
  return table.concat(location, sep)
end

function M.get(opts)
  local apply_hl = opts and opts.apply_hl or false
  local bufnr = opts and opts.bufnr or vim.api.nvim_get_current_buf()
  local data = M.get_data(bufnr)

  if not data or #data == 0 then
    return ''
  end
  return M.format_data(data, apply_hl)
end

return M
