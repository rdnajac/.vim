return {
  {
    'mason-org/mason.nvim',
    build = ':MasonUpdate',
    opts = { ui = { icons = require('nvim.ui.icons').mason.emojis } },
  },
  {
    'folke/lazydev.nvim',
    opts = {
      -- integrations = { cmp = false },
      library = {
        { path = 'snacks.nvim', words = { 'Snacks' } },
        { path = 'mini.nvim', words = { 'Mini.*' } },
        { path = 'nvim', words = { 'nv' } },
      },
    },
  },
}
