_G.nv = setmetatable({}, {
  __index = function(t, k)
    local ok, mod = pcall(require, 'nvim.util.' .. k)
    if not ok then
      return nil
    end
    rawset(t, k, mod)
    return mod
  end,
})

local submodules = vim.tbl_map(function(f)
  return f:match('^.*lua/(nvim/.*)/init%.lua')
end, vim.api.nvim_get_runtime_file('lua/nvim/*/init.lua', true))

local iter = vim.iter(submodules)

local specs = iter
  :map(function(modname)
    local ok, mod = pcall(require, modname)
    if ok and mod then
      local key = modname:match('([^./]+)$')
      -- local key = vim.fn.fnamemodify(modname, ':t')
      -- print(modname .. ' ' .. key)
      rawset(nv, key, mod)
    end
    return mod
  end)
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
