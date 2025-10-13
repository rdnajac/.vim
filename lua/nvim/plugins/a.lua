return {
  {
    'folke/snacks.nvim',
    opts = require('nvim.snacks.opts'),
    keys = function()
      return require('nvim.snacks.keys')
    end,
    after = function()
      require('nvim.snacks.commands')
      require('nvim.snacks.toggles')
    end,
  },
  require('nvim.plugins._core.tokyonight'),
  require('nvim.plugins._core.which-key'),
}
