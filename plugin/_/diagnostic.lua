local nv = _G.nv or require('nvim')

local signs = (function()
  local icon, hl = {}, {}
  ---@type number, string
  for k, v in ipairs(vim.diagnostic.severity) do
    local name = nv.capitalize(v --[[@as string]])
    icon[k] = nv.icons.diagnostics[name] or name:sub(1, 1)
    hl[k] = 'Diagnostic' .. name
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
