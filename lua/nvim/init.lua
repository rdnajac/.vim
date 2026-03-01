--- Defines the structure of modules under the `nvim/` directory
---@class nv.Submodule
---@field specs plug.Spec[]
---@field after fun():nil
---@field status? fun():string

-- local fn, fs, uv = vim.fn, vim.fs, vim.uv
-- local dir = fs.dirname(debug.getinfo(1).source:gsub('^@', ''))
-- local files = fn.globpath(dir, '*/init.lua', false, true)
-- vim.iter(files):map(function(file) return file:gsub('^.*(nvim/.+)$', '%1') end)
--   :map(fs.dirname):map(function(modname)
--     local submod = require(modname)
--     local key = fs.basename(modname)
--     M[key] = submod
--     return submod
--   end)

---@type table<string, nv.Submodule>
local M = {
  blink = require('nvim.blink'),
  keys = require('nvim.keys'),
  lsp = require('nvim.lsp'),
  mini = require('nvim.mini'),
  plug = require('nvim.plug'),
  snacks = require('nvim.snacks'),
  treesitter = require('nvim.treesitter'),
  ui = require('nvim.ui'),
  util = require('nvim.util'),
}

return M
