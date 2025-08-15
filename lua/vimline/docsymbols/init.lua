local lib = require('vimline.docsymbols.navic_lib')

local config = {
  icons = _G.icons.kinds,
  depth_limit = 0,
  depth_limit_indicator = icons.misc.dots,
  -- lazy_update_context = false,
  separator = '',
  hl = {
    icon = 'Constant',
    text = 'Chromatophore_y',
    sep = 'Constant',
  },
}

setmetatable(config.icons, {
  __index = function()
    return '? '
  end,
})

for name, num in pairs(vim.lsp.protocol.SymbolKind) do
  if type(name) == 'string' then
    config.icons[num] = config.icons[name]
  end
end

local M = {}

M.attach = require('vimline.docsymbols.navic_attach')

function M.is_available(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  return vim.b[bufnr].navic_client_id ~= nil
end

-- returns table of context or nil
---@param bufnr number
---@return table|nil
function M.get_data(bufnr)
  local context_data = lib.get_context_data(bufnr)

  if not context_data then
    return nil
  end

  local ret = {}

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

  return ret
end

---@param data table|nil
---@param apply_hl? boolean
---@return string
function M.format_data(data, apply_hl)
  if not data then
    return ''
  end
  apply_hl = apply_hl or false

  local function maybe_hl(hl, text)
    return apply_hl and ("%#" .. hl .. "#" .. text) or text
  end

  local function sanitize_name(v)
    local name = v.name or ''
    name = name:gsub('%%', '%%%%')
    name = name:gsub('\n', ' ')
    return name
  end

  local location = vim.tbl_map(function(v)
    return maybe_hl(config.hl.icon, v.icon)
         .. maybe_hl(config.hl.text, sanitize_name(v))
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
  return M.format_data(data, apply_hl)
end

return M
