local _, ok = pcall(require, 'schemastore')
if not ok then
  return {}
end

---@type vim.lsp.Config
return {
  ---@type lspconfig.settings.jsonls
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      -- https://github.com/b0o/SchemaStore.nvim/issues/8
      validate = { enable = true },
    },
  },
}
