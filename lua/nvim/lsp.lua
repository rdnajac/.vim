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

M.config = function()
  vim.lsp.config('*', { on_attach = require('nvim.lsp.on_attach') })
  vim.lsp.enable(M.servers)
  -- require('nvim.lsp.progress')
  -- require('nvim.lsp.completion')
  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('LazyDevSetup', { clear = true }),
    pattern = 'lua',
    once = true,
    callback = function()
      require('nvim.lsp.lazydev')
    end,
  })
end

return M
