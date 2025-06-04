
return {
  {
    'mason-org/mason.nvim',
    event = "VeryLazy",
    opts = {
      ui = {
        icons = {
          package_installed = '✓',
          package_pending = '➜',
          package_uninstalled = '✗',
        },
      },
    },
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    event = 'VeryLazy',
    dependencies = { 'mason-org/mason.nvim' },
    opts_extend = { 'ensure_installed' },
    opts = { ensure_installed = { 'prettier' } },
  },
  { import = 'nvim.lazy.spec.lang' },
}
