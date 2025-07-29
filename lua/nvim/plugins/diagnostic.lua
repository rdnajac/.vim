local M = { 'dense-analysis/ale' }

---@type vim.diagnostic.Opts
M.opts = {
  float = { source = true },
  underline = false,
  virtual_text = false,
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
      [vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
      [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
      [vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'Statement',
      [vim.diagnostic.severity.WARN] = 'DiagnosticWarn',
      [vim.diagnostic.severity.INFO] = 'DiagnosticInfo',
      [vim.diagnostic.severity.HINT] = 'DiagnosticHint',
    },
  },
}

-- TODO: try ALE counts
---Get diagnostic counts for a buffer.
---@param bufnr number?  Buffer number (defaults to 0)
---@return number errors, number warnings, number infos, number hints
M.counts = function(bufnr)
  bufnr = bufnr or 0
  local errors, warnings, infos, hints = 0, 0, 0, 0
  for _, d in ipairs(vim.diagnostic.get(bufnr)) do
    if d.severity == vim.diagnostic.severity.ERROR then
      errors = errors + 1
    elseif d.severity == vim.diagnostic.severity.WARN then
      warnings = warnings + 1
    elseif d.severity == vim.diagnostic.severity.INFO then
      infos = infos + 1
    elseif d.severity == vim.diagnostic.severity.HINT then
      hints = hints + 1
    end
  end
  return errors, warnings, infos, hints
end

M.config = function()
  vim.diagnostic.config(M.opts)
end

return M
