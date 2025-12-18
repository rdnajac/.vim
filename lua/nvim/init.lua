_G.nv = setmetatable({
  import = function(modname)
    -- local require = require('nvim.util.fn.xprequire')
    -- local mod = require(modname)
    local ok, mod = pcall(require, modname)
    if not ok and mod then
      local key = modname:match('([^./]+)$')
      rawset(nv, key, mod)
    end
    return mod
  end,

  --- Get a `vim.iter` over the files in the caller's directory
  ---@param dir? string defaults to the calling script's directory
  ---@param pattern? string defaults to `*` if omitted
  ---@param antipattern? string defaults to `init.lua` if omitted
  ---return Iter
  ---return string[] files
  submodules = function(dir, pattern, antipattern)
    dir = dir or vim.fs.dirname(debug.getinfo(2, 'S').source:sub(2))
    pattern = pattern or '*'
    antipattern = antipattern or 'init.lua'
    local files = vim.fn.globpath(dir, pattern, false, true)
    local iter = vim.iter(files)
    return iter
      :filter(function(f)
        return not vim.endswith(f, antipattern)
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

local specs = vim
  .iter(nv.submodules())
  :map(nv.import)
  :map(function(mod)
    return type(mod) == 'table' and ((mod.spec and mod.spec) or mod) or nil
  end)
  :fold({}, function(acc, t)
    for _, v in ipairs(t) do
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
