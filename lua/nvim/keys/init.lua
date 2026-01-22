Snacks.keymap.set('n', 'K', vim.lsp.buf.hover, { lsp = {}, desc = 'LSP Hover' })
Snacks.util.on_key('<Esc>', function() vim.cmd.nohlsearch() end)

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

local init = function()
  M = vim.tbl_extend('error', M, require('nvim.keys.toggles'))
  for _, mod in ipairs({ 'extra', 'brackets', 'pickerpairs' }) do
    vim.list_extend(M, require('nvim.keys.' .. mod))
  end
  -- register keymaps (array items)
  for _, keymap in ipairs(M) do
    vim.keymap.set(_parse(keymap))
  end
  -- register toggles (dictionary items)
  -- stylua: ignore
  for key, v in pairs(M) do
    if type(key) == 'string' then
      if type(v) == 'string' then Snacks.toggle.option(v):map(key)
      elseif type(v) == 'table' and not vim.islist(v) then Snacks.toggle.new(v):map(key)
      elseif type(v) == 'function' then v():map(key)
      end
    end
  end
end

vim.schedule(init)

return setmetatable(M, {
  __call = function(_, t)
    if vim.islist(t) then
      vim.list_extend(M, t)
    elseif type(t) == 'table' then
      for k, v in pairs(t) do
        M[k] = v
      end
    end
  end,
})
