--- Defines the structure of modules under the `nvim/` directory
---@class nv.Submodule
---@field specs plug.Spec[]
---@field after? fun():nil
---@field status? fun():string

---@type table<string, nv.Submodule>
_G.nv = {
  blink = require('nvim.blink'),
  fs = require('nvim.fs'),
  keys = require('nvim.keys'),
  lsp = require('nvim.lsp'),
  plug = require('nvim.plug'),
  treesitter = require('nvim.treesitter'),
  ui = require('nvim.ui'),
}

vim.iter(nv):each(function(k, v)
  local modname = 'nvim/' .. k
  vim.keymap.set(
    'n',
    '\\\\' .. k:sub(1, 1),
    function() vim.fn['edit#luamod'](modname) end,
    { desc = 'Edit ' .. modname }
  )
  if v.specs then
    Plug(v.specs)
  end
  if vim.is_callable(v.after) then
    vim.schedule(v.after)
  end
end)

nv.util = require('nvim.util')

return nv
