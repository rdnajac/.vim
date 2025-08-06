require('munchies.config')
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

require('munchies.chromatophore')

Snacks.util.on_module('oil', function()
  require('munchies.oil')
end)
