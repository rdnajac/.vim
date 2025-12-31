local M = {
  blink = require('nvim.blink'),
  lazy = require('nvim.lazy'),
  lsp = require('nvim.lsp'),
  treesitter = require('nvim.treesitter'),
  plugins = require('nvim.plugins'),
}

return setmetatable(M, {
  -- new index that just oprints wjen a module is required
  -- __newindex = function(t, k, v)
  --   print('set: ' .. k)
  --   rawset(t, k, v)
  -- end,
  __index = function(t, k)
    -- Snacks.notify('access:n ' .. k)
    t[k] = require('nvim.util.' .. k)
    return rawget(t, k)
  end,
})
