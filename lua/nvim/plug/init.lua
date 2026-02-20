-- TODO: build command to force rebuild of a plugin
vim.api.nvim_create_autocmd({ 'PackChanged' }, {
  callback = function(ev) require('nvim.plug.build')(ev) end,
})

return {
  load = require('nvim.plug.load'),
  spec = require('nvim.plug.spec'),
  specs = require('nvim._plugins'),
  after = function()
    vim.env.PACKDIR = vim.g.PACKDIR -- TODO: who sets this global??

    local spec_names = function()
      return vim.tbl_map(function(p) return p.spec.name end, vim.pack.get())
    end

    local unloaded = function()
      return vim
        .iter(vim.pack.get())
        :filter(function(p) return not p.active end)
        :map(function(p) return p.spec.name end)
        :totable()
    end

    vim.api.nvim_create_user_command('PlugStatus', function()
      vim.pack.update(nil, { _offline = true })
      -- TODO: print the number of loaded plugins / total plugins
    end, {})

    vim.api.nvim_create_user_command('PlugUpdate', function(opts)
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

    vim.api.nvim_create_user_command('PlugClean', function(opts)
      local plugs = #opts.fargs > 0 and opts.fargs or unloaded()
      vim.pack.del(plugs)
    end, {
      nargs = '*',
      complete = function(_, _, _) return unloaded() end,
    })
  end,
}
