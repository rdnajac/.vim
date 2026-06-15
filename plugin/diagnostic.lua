local severity = vim.diagnostic.severity
local icons = {
  [severity.ERROR] = '',
  [severity.WARN] = '',
  [severity.INFO] = '',
  [severity.HINT] = '',
}

-- local hl_map = {
--   [severity.ERROR] = 'DiagnosticSignError',
--   [severity.WARN] = 'DiagnosticSignWarn',
--   [severity.INFO] = 'DiagnosticSignInfo',
--   [severity.HINT] = 'DiagnosticSignHint',
-- }

vim.diagnostic.config({
  float = { source = true },
  underline = false,
  virtual_text = false,
  severity_sort = true,
  signs = { text = icons },
  -- signs = { text = { '', '', '', '' } },
})
