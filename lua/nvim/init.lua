_G.nv = require('nvim.util')
nv.root = vim.fs.dirname(vim.fs.abspath(debug.getinfo(1).source:sub(2)))
nv.import = function(modname)
  local require = nv.fn.xprequire
  local module = require(modname)
  if type(module) == 'table' then
    local key = modname:match('([^./]+)$')
    rawset(_G.nv, key, module)
  end
  return module
end

local submodules = {
  'nvim.config',
  'nvim.tokyonight',
  'nvim.snacks',
  'nvim.blink',
  'nvim.lazy',
  'nvim.lsp',
  'nvim.mini',
  'nvim.plugins',
  'nvim.treesitter',
}

nv.specs = vim
  .iter(submodules)
  :map(nv.import)
  :map(function(m)
    return (m.spec and m.spec) or (vim.islist(m) and m) or { m }
  end)
  :flatten()
  :map(function(plugin)
    return nv.plug(plugin):tospec()
  end)
  :totable()

local vim_plugins = vim.islist(vim.g.plugs) and vim.g.plugs
  or vim.tbl_map(function(plug)
    return plug.uri
  end, vim.tbl_values(vim.g.plugs or {}))

vim.pack.add(vim.list_extend(nv.specs, vim_plugins), {
  ---@param plug_data { spec: vim.pack.Spec, path: string }
  load = function(plug_data)
    local spec = plug_data.spec
    local name = spec.name
    vim.cmd.packadd({ args = { name }, bang = true, magic = { file = false } })
    if spec.data and vim.is_callable(spec.data.setup) then
      spec.data.setup()
    end
  end,
})

return nv
