_G.nv = _G.nv or require('nvim.util')

local path = vim.fs.joinpath(vim.g.luaroot, 'nvim', 'plugins')
local files = vim.fn.globpath(path, '*.lua', false, true)
local iter = vim.iter(files)

nv.keys = {}
nv.specs = iter
  :map(function(file)
    local modname = file:sub(#vim.g.luaroot + 2, -5)
    return require(modname)
  end)
  :map(function(mod)
    return vim.islist(mod) and mod or { mod }
  end)
  :flatten()
  :map(nv.plug)
  :filter(function(p)
    return p.enabled ~= false
  end)
  :map(function(p)
    return p:tospec()
  end)
  :totable()

vim.pack.add(nv.specs, {
  ---@param plug_data { spec: vim.pack.Spec, path: string }
  load = function(plug_data)
    local spec = plug_data.spec
    -- local path = plug_data.path
    vim.cmd.packadd({ spec.name, bang = true, magic = { file = false } })
    -- local setup = spec.data and spec.data.setup
    if not spec.data then
      return
    end
    if vim.is_callable(spec.data.setup) then
      spec.data.setup()
      -- dd(spec.name) -- earliest `Snacks` are available
    end
    nv.keys[spec.name] = spec.data.keys
  end,
})

-- run all `setup` functions in `nvim/config/*.lua` after startup
-- nv.config = {}
vim.schedule(function()
  nv.for_each_submodule('nvim', 'config', function(mod, name)
    mod.setup()
    -- nv.config[name] = mod
  end)
end)
