-- TODO: finish this and notify modules
local dbug = require('nvim.util.debug')
_G.bt = dbug.bt
-- _G.dd = dbug.dd
_G.dd = function(...)
  return Snacks and Snacks.debug(...) or vim.print(...)
end
_G.pp = dbug.pp

local M = {
  folke = require('folke'), -- must be first
  blink = require('nvim.blink'),
  lsp = require('nvim.lsp'),
  mini = require('nvim.mini'),
  treesitter = require('nvim.treesitter'),
  plugins = require('nvim.plugins'),
  plug = require('plug'),
}
-- collect specs
M.specs = vim
  .iter(vim.tbl_values(M))
  :map(function(v)
    return v.spec
  end)
  :flatten()
  :totable()

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
