_G.nv = require('nvim.util')

local submodules = {
  'nvim.config',
  'nvim.tokyonight',
  'nvim.snacks',
  'nvim.lazy',
  'nvim.lsp',
  'nvim.mini',
  'nvim.plugins',
  'nvim.treesitter',
}

local specdict = {}

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

nv.init = function()
  vim.pack.add(nv.specs, {
    ---@param plug_data {spec: vim.pack.Spec, path: string}
    load = function(plug_data)
      local spec = plug_data.spec
      vim.cmd.packadd({ spec.name, bang = true, magic = { file = false } })
      if spec.data and vim.is_callable(spec.data.setup) then
        spec.data.setup()
      end
    end,
  })
end

return nv
