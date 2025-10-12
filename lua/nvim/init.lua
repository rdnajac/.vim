_G.nv = _G.nv or require('nvim.util')

--- List all lua files in a subdirectory of `lua/nvim/` as module names
--- @param nvim_subdir string subdirectory of `nvim/` to search
--- @return string[] list of module names ready for `require()`
local function submodules(subdir)
  local path = vim.fs.joinpath(vim.g.luaroot, 'nvim', subdir)
  local files = vim.fn.globpath(path, '*.lua', false, true)
  return vim.tbl_map(function(f)
    return f:sub(#vim.g.luaroot + 2, -5)
  end, files)
end

nv.keys = {}
nv.specs = vim
  .iter(submodules('plugins'))
  :map(function(submod)
    return require(submod)
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

vim.pack.add(vim.list_extend(nv.specs, vim.g.plugins or {}), {
  ---@param plug_data { spec: vim.pack.Spec, path: string }
  load = function(plug_data)
    local spec = plug_data.spec
    vim.cmd.packadd({ spec.name, bang = true, magic = { file = false } })

    if spec.data then
      if vim.is_callable(spec.data.setup) then
        spec.data.setup()
      end
      nv.keys[spec.name] = spec.data.keys
    end
  end,
})

-- run all `setup` functions in `nvim/config/*.lua` after startup
vim.schedule(function()
  nv.config = vim.iter(submodules('config')):fold({}, function(acc, submod)
    local mod = require(submod)
    if type(mod.setup) == 'function' then
      mod.setup()
    end
    acc[submod:match('[^/]+$')] = mod
    return acc
  end)
end)
return nv
