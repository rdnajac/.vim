local M = {}

local icons = N.icons.diagnostics

---@type vim.diagnostic.Opts
local opts = {
  float = { source = true },
  underline = false,
  virtual_text = false,
  severity_sort = true,
  signs = { text = {}, numhl = {} },
}

-- set up the signs and highlights for each severity level
for name, severity in pairs(vim.diagnostic.severity) do
  -- capture the severity level as a number and ignore the short names
  if type(severity) == 'number' and #name > 1 then
    local pretty = name:sub(1, 1) .. name:sub(2):lower()
    opts.signs.text[severity] = icons[pretty]
    opts.signs.numhl[severity] = 'Diagnostic' .. pretty
  end
end

vim.diagnostic.config(opts)

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

-- M.config = function()
-- Snacks.util.set_hl({
--   ['1'] = { fg = Snacks.util.color('DiagnosticError'), bg = '#3b4261' },
--   ['2'] = { fg = Snacks.util.color('DiagnosticWarn'), bg = '#3b4261' },
--   ['3'] = { fg = Snacks.util.color('DiagnosticHint'), bg = '#3b4261' },
--   ['4'] = { fg = Snacks.util.color('DiagnosticInfo'), bg = '#3b4261' },
-- }, { prefix = 'User', default = true, managed = true })
-- end

-- force luals to generate a diagnostic
local unused

return M
