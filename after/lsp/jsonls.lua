---@type vim.lsp.Config
local config = {}

local ok, schemastore = pcall(require, 'schemastore')
if ok and schemastore then
  ---@type lspconfig.settings.jsonls
  config.settings = {
    json = {
      schemas = schemastore.json.schemas(),
      -- schemas = require('schemastore').json.schemas(),
      -- https://github.com/b0o/SchemaStore.nvim/issues/8
      validate = { enable = true },
    },
  }
end
return config
