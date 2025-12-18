-- local files = vim.fn.globpath('.', '*', false, true)
-- dd(files)
-- print('once')

_G.nv = setmetatable({
  import = function(modname)
    local ok, mod = pcall(require, modname)
    if ok and mod then
      -- local key = modname:match('([^./]+)$')
      local key = vim.fn.fnamemodify(modname, ':t')
      -- print(modname .. ' ' .. key)
      rawset(nv, key, mod)
    end
    return mod
  end,

  ---@param opts? {dir?: string, pattern?: string}
  ---@return string[] files
  submodules = function(opts)
    opts = opts or {}
    local dir = opts.dir or vim.fs.dirname(debug.getinfo(2, 'S').source:sub(2))
    local pattern = opts.pattern or '*'
    local files = vim.fn.globpath(dir, pattern, false, true)
    dd(dir)

    return vim
      .iter(files)
      :filter(function(f)
        if vim.fn.isdirectory(f) == 1 then
          return vim.uv.fs_stat(f .. '/init.lua') ~= nil
        else
          return not vim.endswith(f, 'init.lua')
        end
      end)
      :map(function(f)
        return vim.fn.fnamemodify(f, ':r:s?^.*/lua/??')
      end)
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
