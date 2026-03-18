local M = {
  progress = require('nvim.lsp.progress'),
  ---@return string[] servers found in the after directory
  servers = function()
    local fn = vim.fn
    return vim.tbl_map(
      function(path) return path:match('^.+/(.+)$'):sub(1, -5) end,
      fn.globpath(vim.fs.joinpath(fn.stdpath('config'), 'after', 'lsp'), '*', false, true)
    )
  end,
  status = require('nvim.lsp.status'),
  specs = {
    'neovim/nvim-lspconfig',
    -- 'b0o/SchemaStore.nvim',
    require('nvim.lsp.lazydev'),
  },
}

vim.schedule(function()
  vim.lsp.enable(M.servers())
  vim.api.nvim_create_autocmd('LspProgress', {
    callback = M.progress.callback,
  })
end)

-- NOTE: blink automatically adds some capabilities
-- `$PACKDIR/blink.cmp/lua/blink/cmp/sources/lib/init.lua`
--- `:h vim.lsp.protocol.make_client_capabilities()` for defaults

return M
