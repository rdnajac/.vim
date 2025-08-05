local M = { 'folke/lazydev.nvim' }

M.opts = {
  library = {
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    { path = 'snacks.nvim', words = { 'Snacks' } },
  },
}

-- HACK: correcrly identify the name of the lsp client
package.preload['lazydev.lsp'] = function()
  local lazydev_path = vim.g.plug_home .. '/lazydev.nvim/'
  local mod = dofile(lazydev_path .. '/lua/lazydev/lsp.lua')
  local orig_supports = mod.supports
  mod.supports = function(client)
    if client and vim.tbl_contains({ 'luals' }, client.name) then
      return true
    end
    return orig_supports(client)
  end
  return mod
end

M.config = function()
  require('lazydev.config').setup(M.opts)
end

return M
