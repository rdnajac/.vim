local M = {}

--- bookmark a submodule for quick access
--- @param key string the key to use (after <Bslash>)
--- @param module string the module as if it were `require`d
local function bookmark(key, module)
  -- stylua: ignore
  return vim.keymap.set('n', '<Bslash>' .. key, function() vim.fn['edit#luamod'](module) end, { desc = 'Edit ' .. module })
end

bookmark('n', 'nvim/init')
bookmark('p', 'plugins')
bookmark('P', 'nvim/util/plug')

local plugins = require('plugins')
local _submodules = {
  blink = true,
  fs = true,
  keys = true,
  lsp = true,
  treesitter = true,
}

for k, v in pairs(_submodules) do
  if v == false then
    return
  end
  M[k] = require('nvim.' .. k)
  bookmark(k:sub(1, 1), 'nvim/' .. k)
  -- collect all plugin specs
  vim.list_extend(plugins, M[k].specs)
end

-- PERF: filter plugins before converting to `vim.pack.Spec`
_G.Plugins = vim.tbl_filter(function(t)
  return t.enabled ~= false
  -- return t.enabled == true end,
end, plugins)

return setmetatable(M, {
  __index = function(t, k)
    local mod = require('nvim.util')[k]
    rawset(t, k, mod)
    return mod
  end,
})
