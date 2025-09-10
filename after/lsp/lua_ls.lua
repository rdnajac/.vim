--- @type vim.lsp.Config
-- bt()
return {
  settings = {
    Lua = {
      diagnostics = { disable = { 'missing-fields' } },
      hover = {
        previewFields = 255,
      },
    },
  },
}
