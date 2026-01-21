Snacks.keymap.set('n', 'K', vim.lsp.buf.hover, { lsp = {}, desc = 'LSP Hover' })
Snacks.util.on_key('<Esc>', function() vim.cmd.nohlsearch() end)

local M = {}

local modes = { n = true, v = true, x = true, i = true, t = true, o = true, c = true, s = true }

local function parse_keymap(t)
  if type(t) ~= 'table' then
    return
  end

  -- Already in correct format: { mode, lhs, rhs, opts }
  if type(t[1]) == 'table' or modes[t[1]] then
    return unpack(t)
  end

  -- Extract mode and opts from named fields
  local mode = t.mode or 'n'
  local opts = type(t[3]) == 'table' and t[3] or {}
  for k, v in pairs(t) do
    if type(k) == 'string' and k ~= 'mode' then
      opts[k] = v
    end
  end

  return mode, t[1], t[2], opts
end

M.add = function(t)
  local is_list = t and type(t[1]) == 'table' and not modes[t[1]]
  for _, keymap in pairs(is_list and t or { t }) do
    local mode, lhs, rhs, opts = parse_keymap(keymap)
    if mode and lhs and rhs then
      vim.keymap.set(mode, lhs, rhs, opts)
    end
  end
end

--- Register toggles from plugin specs and custom toggles
---@param toggles table<string, snacks.toggle.Opts|string|function>
M.register_toggles = function(toggles)
  for key, v in pairs(toggles) do
    local type_ = type(v)
    if type_ == 'table' then
      Snacks.toggle.new(v):map(key)
    elseif type_ == 'string' then
      Snacks.toggle.option(v):map(key)
    elseif type_ == 'function' then
      v():map(key) -- preset toggles
    end
  end
end

return M
