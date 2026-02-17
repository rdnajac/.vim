local M = {
  blink = require('nvim.blink'),
  keys = require('nvim.keys'),
  lsp = require('nvim.lsp'),
  treesitter = require('nvim.treesitter'),
}

local core = require('nvim._plugins')
local iter = vim.iter(M)
M.plugins = iter:fold(core, function(acc, k, v)
  -- print('folding plugins from', k)
  if vim.is_callable(v.after) then
    -- print('scheduling after function for', k)
    vim.schedule(v.after) -- run after startup
  end
  return vim.list_extend(acc, v.specs or {})
end)

M.plug = require('nvim.plug')

return setmetatable(M, {
  __index = function(t, k) -- access: `table[key]`
    -- fall back to util for all other keys
    local mod = require('nvim.util')[k]
    rawset(t, k, mod)
    return mod
  end,
})
