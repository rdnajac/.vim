return {
  {
    'folke/snacks.nvim',
    opts = require('nvim.snacks.opts'),
    keys = function()
      return require('nvim.snacks.keys')
    end,
  },
  require('nvim.plugins._core.tokyonight'),
  require('nvim.plugins._core.which-key'),
}
