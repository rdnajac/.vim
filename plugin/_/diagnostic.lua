local nv = _G.nv or require('nvim')

local signs = (function()
  local icon, hl = {}, {}
  ---@type number, string
  for k, v in ipairs(vim.diagnostic.severity) do
    local diagnostic = v:sub(1, 1) .. v:sub(2):lower()
    icon[k] = nv.icons.diagnostics[diagnostic]
    hl[k] = 'Diagnostic' .. diagnostic
  end
  return { text = icon, numhl = hl }
end)()

---@type vim.diagnostic.Opts
local opts = {
  float = { source = true },
  underline = false,
  virtual_text = false,
  severity_sort = true,
  signs = signs,
  status = signs,
}

local unused = 'smoke test'

vim.diagnostic.config(opts)
