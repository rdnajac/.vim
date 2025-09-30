local M = {}

local unused = 'smoke test'
---@type vim.diagnostic.Opts
local opts = {
  float = { source = true },
  underline = false,
  virtual_text = false,
  severity_sort = true,
  signs = { text = {}, numhl = {} },
}

-- set up the signs and highlights for each severity level
local iter = vim.iter(vim.diagnostic.severity)
iter
  :filter(function(name, severity)
    return type(severity) == 'number' and #name > 1
  end)
  :each(function(name, severity)
    local diagnostic = name:sub(1, 1) .. name:sub(2):lower()
    opts.signs.text[severity] = nv.icons.diagnostics[diagnostic]
    opts.signs.numhl[severity] = 'Diagnostic' .. diagnostic
  end)

vim.diagnostic.config(opts)

-- export status function
M.status = function()
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

return M
