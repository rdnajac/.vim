--- Defines the structure of modules under the `nvim/` directory
---@class nvim.Submodule
---@field specs plug.Spec[]
---@field after fun():nil
---@field status? fun():string

---@type table<string, nvim.Submodule>
local _submodules = {
  blink = require('nvim.blink'),
  keys = require('nvim.keys'),
  fs = require('nvim.fs'),
  lsp = require('nvim.lsp'),
  plug = require('nvim.plug'),
  treesitter = require('nvim.treesitter'),
  ui = require('nvim.ui'),
}

local M = _submodules

_G.nv = M

---@type plug.Spec[]
local plugins = vim.iter(M):fold(require('nvim._plugins'), function(acc, k, v)
  vim.validate('after', v.specs, 'table')
  vim.validate('specs', v.after, vim.is_callable)
  vim.schedule(v.after) -- run after startup
  return vim.list_extend(acc, v.specs)
end)

---@type vim.pack.Spec[]
M.specs = vim
  .iter(plugins)
  :filter(function(t) return t.enabled ~= false end)
  :map(function(t) return M.plug.spec(t):pack() end)
  :totable()

vim.pack.add(M.specs, { load = M.plug.load })

setmetatable(M, {
  __index = function(t, k) -- access: `table[key]`
    -- fall back to util for all other keys
    print('nvim: no submodule for key', k, '- falling back to util')
    local mod = require('nvim.util')[k]
    rawset(t, k, mod)
    return mod
  end,
})

return M
