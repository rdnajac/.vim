-- TODO: finish this and notify modules
local dbug = require('nvim.util.debug')
_G.bt = dbug.bt
-- _G.dd = dbug.dd
_G.dd = function(...) return Snacks and Snacks.debug(...) or vim.print(...) end
_G.pp = dbug.pp

local nv = require('nvim.util') -- exposes all util functions
nv.folke = require('folke')
nv.blink = require('nvim.blink')
nv.lsp = require('nvim.lsp')
nv.mini = require('nvim.mini')
nv.treesitter = require('nvim.treesitter')
nv.plugins = require('nvim.plugins')

-- collect specs
-- nv.specs = vim.iter(vim.tbl_values(nv)):map(function(v) return v.spec end):flatten():totable()
nv.specs = vim
  .iter({ 'folke', 'blink', 'lsp', 'mini', 'treesitter', 'plugins' })
  :map(function(v) return nv[v].spec end)
  :flatten()
  :totable()

return setmetatable(nv, {
  -- __newindex = function(t, k, v)
  --   print('set: ' .. k)
  --   rawset(t, k, v)
  -- end,
  __index = function(t, k)
    t[k] = require('nvim.util.' .. k)
    return rawget(t, k)
  end,
})
