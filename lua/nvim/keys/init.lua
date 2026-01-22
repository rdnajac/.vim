Snacks.keymap.set('n', 'K', vim.lsp.buf.hover, { lsp = {}, desc = 'LSP Hover' })
Snacks.util.on_key('<Esc>', function() vim.cmd.nohlsearch() end)

local M = {}

local modes = { 'n', 'v', 'x', 'i', 't', 'o', 'c', 's' }
local function has_mode(t) return type(t[1]) == 'table' or vim.tbl_contains(modes, t[1]) end

local function _parse(t)
  -- stylua: ignore start
  if type(t) ~= 'table' then return end
  if has_mode(t) then return unpack(t) end
  -- stylua: ignore end

  local lhs, rhs, opts = t[1], t[2], t[3]
  opts = type(opts) == 'table' and opts or {}
  for k, v in pairs(t) do
    if type(k) == 'string' and k ~= 'mode' then
      opts[k] = v
    end
  end
  return t.mode or 'n', lhs, rhs, opts
end

M.queue = {}
M.toggles = require('nvim.keys.toggles')

function M.setup()
  for _, mod in ipairs({ 'extra', 'brackets', 'pickerpairs' }) do
    vim.list_extend(M.queue, require('nvim.keys.' .. mod))
  end

  vim.iter(M.queue):map(_parse):each(vim.keymap.set)
  -- stylua: ignore
  vim.iter(M.toggles):each(function(key, v)
    if type(v) == 'string' then Snacks.toggle.option(v):map(key)
    elseif type(v) == 'table' then Snacks.toggle.new(v):map(key)
    elseif type(v) == 'function' then v():map(key)
    end
  end)
end

return setmetatable(M, {
  __call = function(_, t)
    if vim.islist(t) then
      vim.list_extend(M.queue, t)
    elseif type(t) == 'table' then
      M.toggles = vim.tbl_extend('error', M.toggles, t)
    end
  end,
})
