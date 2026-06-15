Plug({
  {
    'mason-org/mason.nvim',
    ---@module "mason"
    ---@type MasonSettings
    opts = {
      ui = {
        -- icons = { package_installed = '✓', package_pending = '➜', package_uninstalled = '✗' },
        icons = {
          package_installed = ' ',
          package_pending = ' ',
          package_uninstalled = ' ',
        },
        -- icons = { package_installed = '✅', package_pending = '➡️', package_uninstalled = '❌' },
      },
    },
  },
  { 'b0o/SchemaStore.nvim' },
})

-- local lines = vim
--   .iter(require('mason-registry').get_installed_package_names())
--   :map(function(pkg) return '-- ' .. pkg end)
--   :totable()
-- vim.fn.append(vim.fn.line('$'), lines)
