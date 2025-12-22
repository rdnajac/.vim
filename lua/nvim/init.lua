-- ~/.local/share/nvim/site/pack/core/opt/snacks.nvim/lua/snacks/init.lua
local M = setmetatable({}, {
  __index = function(t, k)
    -- print('access: '..k)
    t[k] = require('nvim.util.' .. k)
    return rawget(t, k)
  end,
})

_G.nv = M

-- TODO: register notify setup
-- TODO: register debug setup

local files = vim.api.nvim_get_runtime_file('lua/nvim/*/init.lua', true)
local specs = vim
  .iter(files)
  :map(function(fname)
    -- convert filename to module name
    local modname = fname:match('^.*lua/(nvim/.*)/init%.lua')
    local mod = dofile(fname)
    local key = modname:match('([^./]+)$')
    rawset(M, key, mod)
    return mod
  end)
  :map(function(mod)
    if type(mod) == 'table' then
      return mod.spec or mod -- plugins
    end
  end)
  :fold({}, function(acc, speclist)
    for _, v in ipairs(speclist) do
      table.insert(acc, nv.plug(v):tospec())
    end
    return acc
  end)

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
