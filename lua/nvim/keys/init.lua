Snacks.keymap.set('n', 'K', vim.lsp.buf.hover, { lsp = {}, desc = 'LSP Hover' })
Snacks.util.on_key('<Esc>', function() vim.cmd.nohlsearch() end)

local M = {}

local modes = { n = true, v = true, x = true, i = true, t = true, o = true, c = true, s = true }

local function parse_keymap(t)
  -- stylua: ignore start
  -- skip if not a table
  if type(t) ~= 'table' then return end
  -- return if already in correct format: { mode, lhs, rhs, opts }
  if type(t[1]) == 'table' or modes[t[1]] then return unpack(t) end
  -- stylua: ignore end

  -- Extract mode and opts from named fields
  local lhs, rhs, opts = t[1], t[2], t[3]
  opts = type(opts) == 'table' and opts or {}
  for k, v in pairs(t) do
    if type(k) == 'string' and k ~= 'mode' then
      opts[k] = v
    end
  end
  return t.mode or 'n', lhs, rhs, opts
end

local function add(t)
  local is_list = t and type(t[1]) == 'table' and not modes[t[1]]
  for _, keymap in pairs(is_list and t or { t }) do
    local mode, lhs, rhs, opts = parse_keymap(keymap)
    -- if mode and lhs and rhs then
    vim.keymap.set(mode, lhs, rhs, opts)
    -- end
  end
end

--- Register toggles from plugin specs and custom toggles
---@param toggles table<string, snacks.toggle.Opts|string|function>
local function register_toggles(toggles)
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

setmetatable(M, {
  __call = function(_, k)
    if vim.islist(k) then
      print('is list')
      return add(k)
    end

    print('is not list')
    register_toggles(k)
  end,
})

return M
