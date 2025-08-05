vim.pack.add({ 'folke/snacks.nvim' })
-- use the included icons for other plugins
local icons = require('snacks.picker.config.defaults').defaults.icons

-- merge with the icons from nvim.icons
_G.icons = vim.tbl_deep_extend('force', {}, icons, require('nvim.icons'))

-- setup debug functions
_G.bt = function()
  require('snacks').debug.backtrace()
end

_G.dd = function(...)
  return (function(...)
    return require('snacks').debug.inspect(...)
  end)(...)
end

--  _G.warn =

vim.print = _G.dd
