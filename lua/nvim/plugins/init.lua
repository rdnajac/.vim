local plugins = vim
  .iter(nv.submodules())
  :map(require)
  :map(function(mod)
    return vim.islist(mod) and mod or { mod }
  end)
  :flatten()
  :totable()

return plugins
