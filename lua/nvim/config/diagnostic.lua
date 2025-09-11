--- vim.diagnostic
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
    local diagnostic = name:sub(1, 1) .. name:sub(2):lower()
    opts.signs.text[severity] = nv.icons.diagnostics[diagnostic]
    opts.signs.numhl[severity] = 'Diagnostic' .. diagnostic
  end
end

vim.diagnostic.config(opts)
