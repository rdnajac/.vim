--- @type vim.lsp.Config
return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.luarc.jsonc', 'stylua.toml' },
  settings = {
    Lua = {
      diagnostics = { disable = { 'missing-fields' } },
      hover = {
        previewFields = 255,
      },
    },
  },
}
