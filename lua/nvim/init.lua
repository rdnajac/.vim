_G.nv = require('nvim.util')

local submodules = {
  'nvim.config',
  -- 'nvim.snacks',
  'nvim.tokyonight',
  'nvim.mini',
  'nvim.lsp',
  'nvim.treesitter',
  'nvim.plugins',
}

nv.specs = vim
  .iter(submodules)
  :map(nv.import)
  :map(function(m)
    if vim.is_callable(m.init) then
      m.init()
      return nil
    end
    return m.spec and m.spec or m
  end)
  :flatten()
  :map(function(p)
    return nv.plug(p):tospec()
  end)
  :totable()

nv.init = function()
  vim.pack.add(nv.specs, {
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

return nv
