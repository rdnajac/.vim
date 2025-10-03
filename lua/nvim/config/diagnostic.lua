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
    local group = 'Diagnostic' .. diagnostic

    opts.signs.text[severity] = nv.icons.diagnostics[diagnostic]
    opts.signs.numhl[severity] = group

    -- TODO: use snacks?
    local hl = vim.api.nvim_get_hl(0, { name = group }) or {}
    vim.api.nvim_set_hl(0, group, vim.tbl_extend('force', hl, { bold = true }))
  end)

vim.diagnostic.config(opts)
