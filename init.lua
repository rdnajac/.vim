-- init.lua
-- see `$VIMRUNTIME/example_init.lua`
vim.g.plug_home = vim.fs.joinpath(vim.fn.stdpath('data'), 'site', 'pack', 'core', 'opt')

vim.cmd('runtime vimrc')

vim.loader.enable()

vim.o.cmdheight = 0
vim.o.pumblend = 0
vim.o.winborder = 'rounded'

vim.g.loaded_netrw = 1
-- one of |netrw|snacks|oil
vim.g.default_file_explorer = 'oil'
-- use the new extui module if available
-- local require = require('meta').safe_require
local Plug = require('plug').Plug
-- TODO: use safe require here
require('vim._extui').enable({})

Plug('nvim.snacks')

-- stylua: ignore start
_G.bt = function() Snacks.debug.backtrace() end
_G.ddd = function(...) return Snacks.debug.inspect(...) end
-- stylua: ignore end
vim.print = _G.ddd

Plug('nvim.colorscheme')
Plug('nvim.mini')
Plug('nvim.lsp')
Plug('nvim.treesitter')

_G.icons = require('nvim.icons')
_G.plugins = require('plugins')

require('chromatophore')
require('nvim.config')
