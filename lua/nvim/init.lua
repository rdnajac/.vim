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
  'nvim.tokyonight',
  'nvim.snacks',
  'nvim.blink',
  'nvim.lazy',
  'nvim.lsp',
  'nvim.mini',
  'nvim.plugins',
  'nvim.treesitter',
  'nvim.config',
}

local specdict = {}

-- TODO: specs should be a dictionary of [1] to spec
nv.specs = vim
  .iter(submodules)
  :map(nv.import)
  :map(function(m)
    return (m.spec and m.spec) or (vim.islist(m) and m) or { m }
  end)
  :flatten()
  :map(function(p)
    local plugin = nv.plug(p)
    specdict[plugin[1]] = plugin
    return plugin:tospec()
  end)
  :totable()

  -- TODO: decouple the custom loading from the plugin management
  -- emit an autcmd like jetpac kand hook the setup funcs to those autocmds
vim.pack.add(nv.specs, {
  -- confirm = false,
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
