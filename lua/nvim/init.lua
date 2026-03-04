_G.dd = function(...) require('nvim.util.debug').dd(...) end

--- Defines the structure of modules under the `nvim/` directory
---@class nv.Submodule
---@field specs plug.Spec[]
---@field after? fun():nil
---@field status? fun():string

---@type table<string, nv.Submodule>
local M = {
  blink = require('nvim.blink'),
  keys = require('nvim.keys'),
  fs = require('nvim.fs'),
  lsp = require('nvim.lsp'),
  mini = require('nvim.mini'),
  snacks = require('nvim.snacks'),
  treesitter = require('nvim.treesitter'),
  ui = require('nvim.ui'),
  util = require('nvim.util'),
}

local keys = {} ---@type string[]
for k, v in pairs(M) do
  vim.validate('submodule', v, 'table')
  vim.validate('specs', v.specs, vim.islist)
  -- vim.validate('after', v.after,  'function' , true)
  keys[#keys + 1] = k
  if vim.is_callable(v.after) then
    vim.schedule(v.after)
  end
end

local plug = require('plug')
-- iterate over they keys instead of `M` to allow `flatten()`
---@type vim.pack.Spec[]
local speclist = vim
  .iter(keys)
  :map(function(k) return M[k].specs end)
  :flatten()
  :filter(function(spec) return spec.enabled ~= false end)
  :map(plug.new)
  :map(function(plugin) return plugin:to_pack_spec() end)
  :totable()

vim.pack.add(speclist, { load = plug.load })

return M
