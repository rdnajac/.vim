--- see `:h vim.lsp.protocol.make_client_capabilities()` for defaults
--- NOTE: blink.cmp will automatically add additional capabilities
--- `$PACKDIR/blink.cmp/lua/blink/cmp/sources/lib/init.lua`

local M = {
  servers = function()
    return vim
      .iter(vim.fn.globpath(vim.fn.stdpath('config') .. '/after/lsp', '*', false, true))
      :map(function(path) return vim.fn.fnamemodify(path, ':t:r') end)
      :totable()
  end,
}

vim.schedule(function()
  local progress_callback = require('nvim.lsp.progress').callback
  vim.api.nvim_create_autocmd('LspProgress', {
    callback = function(ev)
      progress_callback(ev)
      vim.cmd.redrawstatus()
    end,
  })
  -- enable servers found in `after/`
  vim.lsp.enable(M.servers())
end)

return M
