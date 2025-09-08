local M = {}

-- TODO: check whether the configs in after/lsp actually override the default configs
M.specs = {
  -- 'neovim/nvim-lspconfig',
  'b0o/SchemaStore.nvim',
}

---@type string[] The list of LSP servers to configure and enable from `lsp/`
M.servers = vim.tbl_map(function(path)
  return path:match('^.+/(.+)%.lua$')
end, vim.api.nvim_get_runtime_file('lsp/*.lua', true))

vim.lsp.config('*', { on_attach = require('nvim.lsp.on_attach') })
vim.lsp.enable(M.servers)

-- TODO:make this a toggle
vim.lsp.inline_completion.enable() -- XXX:

require('nvim.lsp.progress')
require('nvim.lsp.lazydev').setup()

return M
