--- @type vim.lsp.Config
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
