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

-- local opts = require('nvim.colorscheme').opts
-- _G.colors = require('tokyonight').load(opts)
_G.munchies = require('munchies')
_G.plugins = require('plugins')
