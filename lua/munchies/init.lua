local M = { 'folke/snacks.nvim' }

M.opts = require('munchies.config')

M.spec = 'http://github.com/' .. M[1]

-- M.icons = require('snacks.picker.config.defaults').defaults.icons

M.config = function()
  require('snacks').setup(M.opts)

  -- make icons globally available
  local snacks = require('snacks.picker.config.defaults').defaults.icons
  local mine = require('nvim.icons')

  -- _G.icons = vim.tbl_deep_extend('force', {}, M.icons, mine)
  _G.icons = vim.tbl_deep_extend('force', {}, snacks, mine)

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
end

return M
