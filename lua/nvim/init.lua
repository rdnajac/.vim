-- init.lua
-- see `$VIMRUNTIME/example_init.lua`
vim.loader.enable()

vim.o.cmdheight = 0
vim.o.pumblend = 0
vim.o.winborder = 'rounded'

vim.g.loaded_netrw = 1
-- one of |netrw|snacks|oil
vim.g.default_file_explorer = 'oil'

-- use the new extui module if available
pcall(function()
  require('vim._extui').enable({})
end)

_G.colors = require('nvim.colorscheme').config()

require('nvim.snacks').config()

-- use the included icons for other plugins
local icons = require('snacks.picker.config.defaults').defaults.icons

-- merge with the icons from nvim.icons
_G.icons = vim.tbl_deep_extend('force', {}, icons, require('nvim.icons'))

-- setup debug functions
_G.bt = function()
  Snacks.debug.backtrace()
end

_G.dd = function(...)
  return (function(...)
    return Snacks.debug.inspect(...)
  end)(...)
end

vim.print = _G.dd

_G.plugins = require('plugins')
require('chromatophore')
require('nvim.config')
