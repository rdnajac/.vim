local M = {
  blink = require('nvim.blink'),
  lazy = require('nvim.lazy'),
  lsp = require('nvim.lsp'),
  mini = require('nvim.mini'),
  treesitter = require('nvim.treesitter'),
  plugins = require('nvim.plugins'),
}

return setmetatable(M, {
  -- __newindex = function(t, k, v)
  --   print('set: ' .. k)
  --   rawset(t, k, v)
  -- end,
  __index = function(t, k)
    t[k] = require('nvim.util.' .. k)
    return rawget(t, k)
  end,
})
