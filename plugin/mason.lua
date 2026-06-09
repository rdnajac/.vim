---@module "mason"
_G.Plug({
  'mason-org/mason.nvim',
  ---@type MasonSettings
  opts = {
    ui = {
      -- icons = { package_installed = '✓', package_pending = '➜', package_uninstalled = '✗' },
      icons = { package_installed = ' ', package_pending = ' ', package_uninstalled = ' ' },
      -- icons = { package_installed = '✅', package_pending = '➡️', package_uninstalled = '❌' },
    },
  },
})

-- local lines = vim
--   .iter(require('mason-registry').get_installed_package_names())
--   :map(function(pkg) return '-- ' .. pkg end)
--   :totable()
-- vim.fn.append(vim.fn.line('$'), lines)
