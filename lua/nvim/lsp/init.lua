--- see `:h vim.lsp.protocol.make_client_capabilities()` for defaults
-- NOTE: blink automatically adds some capabilities
-- ~/.local/share/nvim/site/pack/core/opt/blink.cmp/lua/blink/cmp/sources/lib/init.lua
local M = {
  status = require('nvim.lsp.status'),
}

M.specs = {
  'neovim/nvim-lspconfig',
  -- 'b0o/SchemaStore.nvim',
  require('nvim.lsp.lazydev')
}

M.after = function()
  local lsp_config_dir = vim.fs.joinpath(vim.fn.stdpath('config'), 'after', 'lsp')
  M.servers = vim.tbl_map(
    function(path) return path:match('^.+/(.+)$'):sub(1, -5) end,
    vim.fn.globpath(lsp_config_dir, '*', false, true)
  )
  vim.lsp.enable(M.servers)

  M.progress = require('nvim.lsp.progress')
  vim.api.nvim_create_autocmd('LspProgress', {
    callback = M.progress.callback,
  })
end

return M
