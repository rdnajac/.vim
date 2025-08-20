local M = {}

---@type vim.diagnostic.Opts
M.opts = {
  float = { source = true },
  underline = false,
  virtual_text = false,
  severity_sort = true,
  signs = { text = {}, numhl = {} },
}

local icons = N.icons.diagnostics

-- set up the signs for each severity level
for severity, name in pairs(vim.diagnostic.severity) do
  if type(severity) == "number" then
    local pretty = name:sub(1, 1) .. name:sub(2):lower()
    M.opts.signs.text[severity]  = icons[pretty]
    M.opts.signs.numhl[severity] = "Diagnostic" .. pretty
  end
end

M.component = function()
  local counts = vim.diagnostic.count(0)
  local signs = vim.diagnostic.config().signs

  if not signs or vim.tbl_isempty(counts) then
    return ''
  end

  return vim
    .iter(pairs(counts))
    :map(function(severity, count)
      local icon = signs.text[severity]
      local hl_group = signs.numhl[severity]
      return string.format('%%#%s#%s:%d', hl_group, icon, count)
    end)
    :join('')
end

M.config = function()
  vim.diagnostic.config(M.opts)
  -- Snacks.util.set_hl({
  --   ['1'] = { fg = Snacks.util.color('DiagnosticError'), bg = '#3b4261' },
  --   ['2'] = { fg = Snacks.util.color('DiagnosticWarn'), bg = '#3b4261' },
  --   ['3'] = { fg = Snacks.util.color('DiagnosticHint'), bg = '#3b4261' },
  --   ['4'] = { fg = Snacks.util.color('DiagnosticInfo'), bg = '#3b4261' },
  -- }, { prefix = 'User', default = true, managed = true })
end

return M
