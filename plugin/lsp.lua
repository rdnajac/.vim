--- see `:h vim.lsp.protocol.make_client_capabilities()` for defaults
--- NOTE: blink.cmp will automatically add additional capabilities
--- `$PACKDIR/blink.cmp/lua/blink/cmp/sources/lib/init.lua`

local servers = function()
  return vim
    .iter(vim.fn.globpath(vim.fn.stdpath('config') .. '/after/lsp', '*', false, true))
    :map(function(path) return vim.fn.fnamemodify(path, ':t:r') end)
    :totable()
end

-- vim.api.nvim_create_autocmd('LspAttach', {
--   callback = function(ev)
--     local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
--     if client:supports_method('textDocument/foldingRange') then
--       local win = vim.api.nvim_get_current_win()
--       vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
--     end
--   end,
-- })

vim.api.nvim_create_autocmd('LspProgress', {
  callback = function(ev)
    local progress_callback = require('nvim.lsp.progress').callback
    progress_callback(ev)
    vim.cmd.redrawstatus()
  end,
})

vim.schedule(function()
  vim.lsp.enable(servers())
end)
