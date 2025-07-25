-- init.lua
vim.loader.enable()

vim.o.cmdheight = 0
vim.o.pumblend = 0
vim.o.winborder = 'rounded'
require('vim._extui').enable({})

require('munchies')
-- 1. requires snacks setup
-- 2. registers vim commands

-- make icons globally available
local snacks = require('snacks.picker.config.defaults').defaults.icons
local mine = require('nvim.icons')

_G.icons = vim.tbl_deep_extend('force', {}, snacks, mine)

_G.dd = function(...)
  return (function(...)
    return Snacks.debug.inspect(...)
  end)(...)
end

vim.print = _G.dd

-- stylua: ignore
_G.bt = function() Snacks.debug.backtrace() end

-- TODO:
-- start an instance of nvim in the background without a ui attached
-- on startup, attach to ui, then try out remote plugins and eval expr
-- TODO:
-- neovim as an http server attach to instance view the buffers (logfiles)
