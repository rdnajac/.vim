ddd('config/lazy/spec/lang/init.lua')
-- BUG: why is this printing twice?
return {
  {
    'mason-org/mason.nvim',
    build = ':MasonUpdate',
    event = 'VeryLazy',
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
    opts = {
      ensure_installed = { 'prettier' },
    },
  },
  { import = 'config.lazy.spec.lang' },
}
