_G.nv = _G.nv or require('nvim.util')

require('nvim.config')

nv.specs = vim
  .iter(nv.submodules('plugins'))
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

    if spec.data and vim.is_callable(spec.data.setup) then
      spec.data.setup()
    end
  end,
})

Snacks.picker.scriptnames = function()
  require('nvim.snacks.picker.scriptnames')
end
