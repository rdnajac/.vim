-- ~/.local/share/nvim/site/pack/core/opt/snacks.nvim/lua/snacks/init.lua
local M = {
  lazy = require('nvim.lazy'),
  lsp = require('nvim.lsp'),
  treesitter = require('nvim.treesitter'),
}

-- TODO: register notify setup
-- TODO: register debug setup
_G.nv = setmetatable(M, {
  __index = function(t, k)
    -- vim.schedule(function()
    --   print('access: ' .. k)
    -- end)
    t[k] = require('nvim.util.' .. k)
    return rawget(t, k)
  end,
})

local plugins = require('nvim.plugins')
local iter = vim.iter(plugins)
local specs = iter
  :map(function(p)
    return nv.plug(p):tospec()
  end)
  :totable()

vim.pack.add(specs, {
  ---@param plug_data {spec: vim.pack.Spec, path: string}
  load = function(plug_data)
    local spec = plug_data.spec
    vim.cmd.packadd({ spec.name, bang = true, magic = { file = false } })
    if spec.data and vim.is_callable(spec.data.setup) then
      spec.data.setup()
    end
  end,
})

return M
