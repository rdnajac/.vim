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
    'mason-lspconfig.nvim',
    enabled = false,
    opts = {
      ensure_installed = {},
    },
  },
  -- { 'SmiteshP/nvim-navic' },
  -- { 'b0o/SchemaStore.nvim' },
}
