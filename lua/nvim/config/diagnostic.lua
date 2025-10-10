local hl = {}
local icons = {}

for k, v in ipairs(vim.diagnostic.severity) do
  local diagnostic = v:sub(1, 1) .. v:sub(2):lower()
  hl[k] = 'Diagnostic' .. diagnostic
  icons[k] = nv.icons.diagnostics[diagnostic]
end

local M = {}

---@type vim.diagnostic.Opts
M.opts = {
  float = { source = true },
  underline = false,
  virtual_text = false,
  severity_sort = true,
  signs = { text = icons, numhl = hl },
}

local unused = 'smoke test'

M.setup = function()
  vim.diagnostic.config(M.opts)
end

return M
