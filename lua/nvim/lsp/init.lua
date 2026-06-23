--- see `:h vim.lsp.protocol.make_client_capabilities()` for defaults
--- NOTE: blink.cmp will automatically add additional capabilities
--- `$PACKDIR/blink.cmp/lua/blink/cmp/sources/lib/init.lua`
local M = {}

M.servers = function()
  local fn = vim.fn
  return vim
    .iter(fn.globpath(fn.stdpath('config') .. '/after/lsp', '*', false, true))
    :map(function(path)
      return fn.fnamemodify(path, ':t:r')
    end)
    :totable()
end

M.enable_servers = function()
  vim.lsp.enable(M.servers())
end

return M
