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
