return {
  { 'neovim/nvim-lspconfig' },
  {
    'mason-org/mason.nvim',
    opts = function()
      return { ui = { icons = nv.icons.mason } }
    end,
    build = vim.cmd.MasonUpdate,
    keys = { { '<leader>cm', '<Cmd>Mason<CR>', desc = 'Mason' } },
  },
  {
    'mason-org/mason-lspconfig.nvim',
    enabled = false,
    lazy = true,
    opts = {
      ensure_installed = {},
      automatic_enable = false,
    },
  },
  -- { 'SmiteshP/nvim-navic' },
  -- { 'b0o/SchemaStore.nvim' },
}
