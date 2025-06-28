-- local icons = LazyVim.config.icons
local icons = require('nvim.ui.icons')

---@type vim.diagnostic.Opts
vim.diagnostic.config({
  underline = false,
  virtual_text = false,
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.diagnostics.error,
      [vim.diagnostic.severity.WARN] = icons.diagnostics.warn,
      [vim.diagnostic.severity.HINT] = icons.diagnostics.hint,
      [vim.diagnostic.severity.INFO] = icons.diagnostics.info,
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'DiagnosticError',
      [vim.diagnostic.severity.WARN] = 'DiagnosticWarn',
      [vim.diagnostic.severity.INFO] = 'DiagnosticInfo',
      [vim.diagnostic.severity.HINT] = 'DiagnosticHint',
    },
  },
})

vim.keymap.set('n', 'ds', function()
  vim.diagnostic.open_float({
    source = true,
    header = '',
  })
end, { desc = 'Show diagnostics' })
