---@type vim.lsp.Config
return {
  ---@type lspconfig.settings.lua_ls
  settings = {
    Lua = {
      completion = { autoRequire = false },
      diagnostics = { disable = { 'missing-fields' } },
      hover = {
        previewFields = 255,
      },
    },
  },
}
