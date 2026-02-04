local spec_names = function()
  return vim.tbl_map(function(p) return p.spec.name end, vim.pack.get())
end

vim.api.nvim_create_user_command(
  'PlugStatus',
  function() vim.pack.update(nil, { _offline = true }) end,
  {}
)

vim.api.nvim_create_user_command('Update', function(opts)
  local plugs = #opts.fargs > 0 and opts.fargs or nil
  vim.pack.update(plugs, { force = opts.bang })
end, {
  nargs = '*',
  bang = true,
  complete = spec_names,
})

vim.api.nvim_create_user_command('PlugSpecs', function(opts)
  local plugins = #opts.fargs > 0 and opts.fargs or nil
  dd(true, vim.pack.get(plugins, { info = opts.bang }))
end, {
  bang = true,
  nargs = '*',
  complete = spec_names,
})

local unloaded = function()
  return vim
    .iter(vim.pack.get())
    :map(function(p)
      if not p.active then
        return p.spec.name
      end
    end)
    :totable()
end

vim.api.nvim_create_user_command('PlugClean', function(opts)
  local plugs = #opts.fargs > 0 and opts.fargs or unloaded()
  vim.pack.del(plugs)
end, {
  nargs = '*',
  complete = function(_, _, _) return unloaded() end,
})
