local icons = nv.ui.icons.diagnostics

---@type vim.diagnostic.Opts
local opts = {
  float = { source = true },
  underline = false,
  virtual_text = false,
  severity_sort = true,
  signs = {
    text = icons,
  },
  status = {
    format = nv.ui.status.render_counts(icons, {
      'DiagnosticSignError',
      'DiagnosticSignWarn',
      'DiagnosticSignInfo',
      'DiagnosticSignHint',
    }),
  },
}

vim.schedule(function() vim.diagnostic.config(opts) end)
