_G.nv = setmetatable({
  import = function(modname)
    -- local require = require('nvim.util.xprequire')
    local module = require(modname)
    -- print('importing ' .. modname)
    if not module then
      error('no mod')
    end
    local key = modname:match('([^./]+)$')
    rawset(nv, key, module)
    return module
  end,
  submodules = function()
    local info = debug.getinfo(2, 'S')
    if not info or info.source:sub(1, 1) ~= '@' then
      return {}
    end
    local path = vim.fs.dirname(info.source:sub(2))
    local files = vim.fn.globpath(path, '*.lua', false, true)
    return vim
      .iter(files)
      :filter(function(f)
        return not vim.endswith(f, 'init.lua')
      end)
      :map(require('nvim.util.fn').modname)
      :totable()
  end,
}, {
  __index = function(t, k)
    local ok, mod = pcall(require, 'nvim.util.' .. k)
    if not ok then
      return nil
    end
    rawset(t, k, mod)
    return mod
  end,
})

local script = debug.getinfo(1, 'S').source:sub(2)
for name, type_ in vim.fs.dir(vim.fs.dirname(script)) do
  if type_ == 'directory' and name ~= 'util' then
    nv.import('nvim.' .. name)
  end
end

local function packadd(specs)
  local speclist = vim
    .iter(specs)
    :map(function(p)
      return nv.plug(p):tospec()
    end)
    :totable()

  vim.pack.add(speclist, {
    ---@param plug_data {spec: vim.pack.Spec, path: string}
    load = function(plug_data)
      local spec = plug_data.spec
      vim.cmd.packadd({ spec.name, bang = true, magic = { file = false } })
      if spec.data and vim.is_callable(spec.data.setup) then
        -- print('setup ' .. spec.name)
        spec.data.setup()
      end
    end,
  })
end

packadd(nv.plugins)
packadd(nv.folke.spec)
packadd(nv.lsp.spec)
packadd(nv.treesitter.spec)
