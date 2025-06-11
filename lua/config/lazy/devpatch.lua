-- HACK: patch before plugin loads
local lazydev_path = require('lazy.core.config').spec.plugins['lazydev.nvim'].dir
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
