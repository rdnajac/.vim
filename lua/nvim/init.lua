-- init.lua
-- see `$VIMRUNTIME/example_init.lua`
vim.loader.enable()

vim.o.cmdheight = 0
vim.o.pumblend = 0
vim.o.winborder = 'rounded'

-- use the new extui module if available
pcall(function()
  require('vim._extui').enable({})
end)

-- _G.colors = require('nvim.colorscheme').load()
require('nvim.plug')
_G.colors = require('nvim.colorscheme').config()
--_G.colors = Plug('nvim.colorscheme')
_G.munchies = require('munchies')
_G.plugins = require('plugins')
