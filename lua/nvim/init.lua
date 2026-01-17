local M = {}

M.blink = require('nvim.blink')
M.keymaps = require('nvim.keymaps')
M.lazy = require('nvim.lazy')
M.lsp = require('nvim.lsp')
M.mini = require('nvim.mini')
-- M.plugins = require('nvim.plugins')
M.treesitter = require('nvim.treesitter')

local _submodules = {
  blink = true,
  keymaps = true,
  lazy = true,
  lsp = true,
  mini = true,
  -- plugins = true,
  treesitter = true,
}

return setmetatable(M, {
  __index = function(t, k)
    if _submodules[k] then
      -- lazy load runtime modules in the `nv` namespace
      -- t[k] = require('nv.' .. k)
      return t[k]
    else
      -- expose all utils  on the `nv` module
      local mod = require('nvim.util')[k]
      if mod ~= nil then
        t[k] = mod
        return t[k]
      end
    end
  end,
})
