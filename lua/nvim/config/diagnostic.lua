local M = {}

---@type nv.status.Component
M.status = {
  ---@param bufnr? number
  ---@return string
  function(bufnr)
    bufnr = bufnr or 0
    local counts = vim.diagnostic.count(bufnr)
    local signs = vim.diagnostic.config().signs
    if not signs then
      return ''
    end
    return vim
      .iter(pairs(counts))
      :map(function(severity, count)
        return string.format('%%#%s#%s:%d%%*', signs.numhl[severity], signs.text[severity], count)
      end)
      :join('')
  end,
  ---@param bufnr? number
  cond = function(bufnr)
    return not vim.tbl_isempty(vim.diagnostic.count(bufnr or 0))
  end,
}

---@type vim.diagnostic.Opts
local opts = {
  float = { source = true },
  underline = false,
  virtual_text = false,
  severity_sort = true,
  signs = (function()
    local icon, hl = {}, {}
    ---@type number, string
    for k, v in ipairs(vim.diagnostic.severity) do
      local diagnostic = v:sub(1, 1) .. v:sub(2):lower()
      icon[k] = nv.icons.diagnostics[diagnostic]
      hl[k] = 'Diagnostic' .. diagnostic
    end
    return { text = icon, numhl = hl }
  end)(),
}

local unused = 'smoke test'

vim.diagnostic.config(opts)

return M
