vim.schedule(function()
  Snacks.keymap.set('n', 'K', vim.lsp.buf.hover, { lsp = {}, desc = 'LSP Hover' })
  Snacks.util.on_key('<Esc>', function() vim.cmd.nohlsearch() end)
end)

local modes = { 'n', 'v', 'x', 'i', 't', 'o', 'c', 's' }
local function has_mode(t) return type(t[1]) == 'table' or vim.tbl_contains(modes, t[1]) end
local function _parse(t)
  -- stylua: ignore
  if has_mode(t) then return unpack(t) end
  local lhs, rhs, opts = t[1], t[2], t[3]
  opts = type(opts) == 'table' and opts or {}
  for k, v in pairs(t) do
    if type(k) == 'string' and k ~= 'mode' then
      opts[k] = v
    end
  end
  return t.mode or 'n', lhs, rhs, opts
end

local M = {}

M.map = function(t) vim.iter(t):map(_parse):each(vim.keymap.set) end
M.map_snacks_toggle = function(key, v)
  -- stylua: ignore
  if type(v) == 'string' then Snacks.toggle.option(v):map(key)
  elseif type(v) == 'table' then Snacks.toggle.new(v):map(key)
  elseif type(v) == 'function' then v():map(key) end
end

return M
