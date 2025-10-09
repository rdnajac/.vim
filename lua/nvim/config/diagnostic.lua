---@type vim.diagnostic.Opts
local opts = {
  float = { source = true },
  underline = false,
  virtual_text = false,
  severity_sort = true,
  signs = { text = {}, numhl = {} },
}

local unused = 'smoke test'

vim
  .iter(vim.diagnostic.severity)
  :filter(function(name, severity)
    return type(severity) == 'number' and #name > 1
  end)
  :each(function(name, severity)
    local diagnostic = name:sub(1, 1) .. name:sub(2):lower()
    opts.signs.numhl[severity] = 'Diagnostic' .. diagnostic
    opts.signs.text[severity] = nv.icons.diagnostics[diagnostic]
  end)

return {
  opts = opts,
  setup = function()
    vim.diagnostic.config(opts)
  end,
}
