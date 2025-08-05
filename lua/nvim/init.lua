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

-- TODO: require wrapper that handles spec-loading
require('munchies')
local opts = require('nvim.colorscheme').opts
_G.colors = require('tokyonight').load(opts)
_G.plugins = require('plugins')

require('munchies')
