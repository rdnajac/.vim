return {
  name = 'config',
  keys = require('nvim.config.keymaps'),
  commands = require('nvim.config.commands'),
  after = function()
    vim.schedule(function()
      require('nvim.config.autocmds')
      require('nvim.config.diagnostic')
      require('nvim.config.sourcecode').setup()
    end)
  end,
}
