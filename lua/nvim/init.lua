require('nvim.autocmds')
require('nvim.colorscheme')

-- TODO:
-- start an instance of nvim in the background without a ui attached
-- on startup, attach to ui, then try out
-- neovim as an http server attach to instance view the buffers (logfiles)

-- exposing snacks functions to global scope
_G.dd = function(...)
  return (function(...)
    return Snacks.debug.inspect(...)
  end)(...)
end

vim.print = _G.dd

-- stylua: ignore
_G.bt = function() Snacks.debug.backtrace() end

-- reuse the kind icons provided by snacks
local icons = icons or require('nvim.icons')
icons.kinds = require('snacks.picker.config.defaults')

_G.nvim = require('nvim.plugins')
