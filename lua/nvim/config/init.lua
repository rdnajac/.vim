-- These need to be set before extui is enabled
vim.o.cmdheight = 0
vim.o.winborder = 'rounded'
require('vim._extui').enable({})

vim.schedule(function()
  require('nvim.config.diagnostic').setup()
  require('nvim.config.keymaps').setup()
  require('nvim.config.lsp').setup()
  require('nvim.config.notify').setup()
  require('nvim.config.sourcecode').setup()
  require('nvim.snacks.toggle')
end)
