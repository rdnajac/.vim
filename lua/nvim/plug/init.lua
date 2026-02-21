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

    vim.api.nvim_create_user_command(
      'PlugStatus',
      function() vim.pack.update(nil, { offline = true }) end,
      {}
    )
    vim.api.nvim_create_user_command(
      'PlugUpdate',
      function(opts) vim.pack.update(#opts.fargs > 0 and opts.fargs or nil, { force = opts.bang }) end,
      {
        nargs = '*',
        bang = true,
        complete = spec_names,
      }
    )
    vim.api.nvim_create_user_command(
      'PlugSpecs',
      function(opts)
        dd(true, vim.pack.get(#opts.fargs > 0 and opts.fargs or nil, { info = opts.bang }))
      end,
      {
        bang = true,
        nargs = '*',
        complete = spec_names,
      }
    )
    vim.api.nvim_create_user_command(
      'PlugClean',
      function(opts) vim.pack.del(#opts.fargs > 0 and opts.fargs or unloaded()) end,
      {
        nargs = '*',
        complete = function(_, _, _) return unloaded() end,
      }
    )
  end,
}
