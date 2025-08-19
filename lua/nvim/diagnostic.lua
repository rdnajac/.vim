local M = {}

---@type vim.diagnostic.Opts
M.opts = {
  float = { source = true },
  underline = false,
  virtual_text = false,
  severity_sort = true,
  signs = {
    text = {
      -- TODO: handle errors gracefully?
      [vim.diagnostic.severity.ERROR] = N.icons.diagnostics.Error,
      [vim.diagnostic.severity.WARN] = N.icons.diagnostics.Warn,
      [vim.diagnostic.severity.HINT] = N.icons.diagnostics.Hint,
      [vim.diagnostic.severity.INFO] = N.icons.diagnostics.Info,
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'Statement',
      [vim.diagnostic.severity.WARN] = 'DiagnosticWarn',
      [vim.diagnostic.severity.INFO] = 'DiagnosticInfo',
      [vim.diagnostic.severity.HINT] = 'DiagnosticHint',
    },
  },
}

vim.diagnostic.config(M.opts)

return M
