--- Defines the structure of modules under the `nvim/` directory
---@class nv.Submodule
---@field specs plug.Spec[]
---@field after fun():nil
---@field status? fun():string

---@type table<string, nv.Submodule>
local M = {
  blink = require('nvim.blink'),
  keys = require('nvim.keys'),
  lsp = require('nvim.lsp'),
  mini = require('nvim.mini'),
  snacks = require('nvim.snacks'),
  treesitter = require('nvim.treesitter'),
  ui = require('nvim.ui'),
  util = require('nvim.util'),
}

return M
