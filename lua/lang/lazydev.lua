local M = { 'folke/lazydev.nvim' }

M.opts = {
  library = {
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    { path = 'snacks.nvim', words = { 'Snacks' } },
  },
}
-- HACK: fix lsp name mismatch
-- local lazydev_path = require('lazy.core.config').spec.plugins['lazydev.nvim'].dir
local lazydev_path = vim.fn.expand('~/.local/share/nvim/site/pack/core/opt/lazydev.nvim/')

package.preload['lazydev.lsp'] = function()
  local mod = dofile(lazydev_path .. '/lua/lazydev/lsp.lua')
  local orig_supports = mod.supports
  mod.supports = function(client)
    -- correcrly identify the name of the lsp client
    if client and vim.tbl_contains({ 'luals' }, client.name) then
      return true
    end
    return orig_supports(client)
  end
  return mod
end

require('lazydev.config').setup(M.opts)

return M
