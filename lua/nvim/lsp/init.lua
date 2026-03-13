--- `capabilities = require('blink.cmp').get_lsp_capabilities()`,
--- see `:h vim.lsp.protocol.make_client_capabilities()` for defaults
local M = {
  status = require('nvim.lsp.status'),
}

M.specs = {
  'neovim/nvim-lspconfig',
  -- 'b0o/SchemaStore.nvim',
  {
    'folke/lazydev.nvim',
    opts = {
      library = {
        vim.env.VIMRUNTIME,
        { path = 'snacks.nvim', words = { 'Snacks' } },
        { path = 'mini.nvim', words = { 'Mini.*' } },
        { path = 'nvim', words = { 'nv' } },
      },
    },
  },
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
