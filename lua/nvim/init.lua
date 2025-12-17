_G.nv = setmetatable({
  import = function(modname)
    -- local require = require('nvim.util.xprequire')
    local module = require(modname)
    local key = modname:match('([^./]+)$')
    rawset(nv, key, module)
    return module
  end,
  --- Get a `vim.iter` over the files in the caller's directory
  ---@return Iter
  submodules = function()
    local caller_path = vim.fs.dirname(debug.getinfo(2, 'S').source:sub(2))
    local files = vim.fn.globpath(caller_path, '*.lua', false, true)
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

-- ---@param dir? string defaults to the calling script's directory
-- ---@param pattern? string defaults to `*` if omitted
-- ---@param antipattern? string defaults to `init.lua` if omitted
-- ---return Iter
-- ---@return string[] files
-- submodules = function(dir, pattern, antipattern)
--   dir = dir or vim.fs.dirname(debug.getinfo(2, 'S').source:sub(2))
--   pattern = pattern or '*'
--   antipattern = antipattern or 'init.lua'
--   return vim.tbl_filter(function(fname)
--     return not vim.endswith(fname, antipattern)
--   end, vim.fn.globpath(dir, pattern, false, true))
-- end,

local script = debug.getinfo(1, 'S').source:sub(2)
local iter = vim.iter(vim.fs.dir(vim.fs.dirname(script)))
local specs = iter
  :filter(function(name, type_)
    return type_ == 'directory' and not vim.tbl_contains({ 'folke', 'util' }, name)
  end)
  :map(function(name)
    return nv.import('nvim.' .. name)
  end)
  :filter(function(mod)
    return type(mod) == 'table'
  end)
  :fold({}, function(acc, mod)
    for _, v in ipairs(mod.spec and mod.spec or mod) do
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
