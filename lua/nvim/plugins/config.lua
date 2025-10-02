return {
  name = 'config',
  keys = function()
    return nv.keymaps
  end,
  commands = nv.commands,
  after = function()
    nv.lazyload(function()
      require('nvim.config.sourcecode').setup()
      require('nvim.config.autocmds')()
    end)
  end,
}
