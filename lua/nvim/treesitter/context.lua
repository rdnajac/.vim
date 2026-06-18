return {
  'nvim-treesitter/nvim-treesitter-context',
  toggle = {
    ['<leader>ux'] = {
      name = 'Treesitter Context',
      get = function() return require('treesitter-context').enabled() end,
      set = function() return require('treesitter-context').toggle() end,
    },
  },
}
