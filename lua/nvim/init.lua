--- Defines the structure of modules under the `nvim/` directory
---@class nv.Submodule
---@field specs plug.Spec[]
---@field after? fun():nil
---@field status? fun():string

---@type table<string, nv.Submodule>
_G.nv = {}
--   blink = require('nvim.blink'),
--   fs = require('nvim.fs'),
--   keys = require('nvim.keys'),
--   lsp = require('nvim.lsp'),
--   plug = require('nvim.plug'),
--   treesitter = require('nvim.treesitter'),
--   ui = require('nvim.ui'),

local fn, fs, uv = vim.fn, vim.fs, vim.uv
local luaroot = fs.joinpath(fn.stdpath('config'), 'lua')
local submodules = fn.globpath(luaroot, 'nvim/*/init.lua', false, true)

vim
  .iter(submodules)
  :map(function(fpath) return fpath:gsub('^.*(nvim/.+)$', '%1'):gsub('/init.lua$', '') end)
  :map(function(modname)
    local key = fs.basename(modname)
    vim.keymap.set(
      'n',
      '\\\\' .. (key == 'util' and 'v' or key:sub(1, 1)),
      function() vim.fn['edit#luamod'](modname) end,
      { desc = 'Edit ' .. modname }
    )
    local mod = require(modname)
    nv[key] = mod
    return mod
  end)
  :each(function(v)
    if v.specs then
      Plug(v.specs)
    end
    if vim.is_callable(v.after) then
      vim.schedule(v.after)
    end
  end)

return nv
