local M = { 'folke/snacks.nvim' }

M.priority = 1000

M.dependencies = { 'folke/tokyonight.nvim' }

M.opts = require('munchies.config')

M.config = function()
  require('snacks').setup(M.opts)

  -- use the included icons
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

  vim.cmd.colorscheme('tokyomidnight')
  require('munchies.chromatophore')
end

return M
