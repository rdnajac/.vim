return {
  name = 'config',
  keys = nv.keymaps,
  commands = nv.commands,
  after = function()
    vim.schedule(function()
      vim.o.winbar = '%{%v:lua.nv.winbar()%}'
      require('nvim.config.sourcecode').setup()
    end)
  end,
}
