---@type vim.diagnostic.Opts
local opts = {
  float = { source = true },
  underline = false,
  virtual_text = false,
  severity_sort = true,
  signs = (function()
    local icon, hl = {}, {}
    ---@param k number
    ---@param v string
    for k, v in ipairs(vim.diagnostic.severity) do
      ---@type string
      local diagnostic = v:sub(1, 1) .. v:sub(2):lower()
      icon[k] = nv.icons.diagnostics[diagnostic]
      hl[k] = 'Diagnostic' .. diagnostic
    end
    return { text = icon, numhl = hl }
  end)(),
}

local unused = 'smoke test'

vim.diagnostic.config(opts)
