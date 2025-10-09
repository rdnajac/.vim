return {
  {
    'mason-org/mason.nvim',
    opts = {
      -- ui = { icons = nv.icons.mason }
    },
    build = ':MasonUpdate',
  },
  { 'neovim/nvim-lspconfig' },
  { 'SmiteshP/nvim-navic' },
  -- { 'b0o/SchemaStore.nvim' },
}
