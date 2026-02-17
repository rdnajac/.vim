--- Defines the structure of modules under the `nvim/` directory
---@class nvim.Submodule
---@field specs plug.Spec[]
---@field after fun():nil

---@type table<string, nvim.Submodule>
local _submodules = {
  blink = require('nvim.blink'),
  keys = require('nvim.keys'),
  lsp = require('nvim.lsp'),
  plug = require('nvim.plug'),
  treesitter = require('nvim.treesitter'),
  ui = require('nvim.ui'),
}

local M = _submodules

M.plugins = vim.iter(_submodules):fold({}, function(acc, k, v)
  vim.schedule(v.after) -- run after startup
  return vim.list_extend(acc, v.specs or {})
end)

setmetatable(M, {
  __index = function(t, k) -- access: `table[key]`
    -- fall back to util for all other keys
    local mod = require('nvim.util')[k]
    rawset(t, k, mod)
    return mod
  end,
})

return M
