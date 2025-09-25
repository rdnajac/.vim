local M = {}

M.specs = {
  -- 'folke/trouble.nvim',
  -- 'mfussenegger/nvim-lint',
}

---@type vim.diagnostic.Opts
local opts = {
  float = { source = true },
  underline = false,
  virtual_text = false,
  severity_sort = true,
  signs = { text = {}, numhl = {} },
}

M.after = function()
  vim
    .iter(vim.diagnostic.severity)
    -- Keep only numeric severities and ignore short keys like "ERROR" -> 1
    :filter(
      function(name, severity)
        return type(severity) == 'number' and #name > 1
      end
    )
    -- Build signs and highlights
    :each(function(name, severity)
      local diagnostic = name:sub(1, 1) .. name:sub(2):lower()
      opts.signs.text[severity] = nv.icon.diagnostics[diagnostic]
      opts.signs.numhl[severity] = 'Diagnostic' .. diagnostic
    end)
  -- set up the signs and highlights for each severity level
  -- for name, severity in pairs(vim.diagnostic.severity) do
  --   -- capture the severity level as a number and ignore the short names
  --   if type(severity) == 'number' and #name > 1 then
  --     local diagnostic = name:sub(1, 1) .. name:sub(2):lower()
  --     opts.signs.text[severity] = nv.icon.diagnostics[diagnostic]
  --     opts.signs.numhl[severity] = 'Diagnostic' .. diagnostic
  --   end
  -- end

  -- TODO: infer this function in load func
  vim.diagnostic.config(opts)
end

local unused_local = 'smoke test'

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
