--- see `:h vim.lsp.protocol.make_client_capabilities()` for defaults
--- NOTE: blink.cmp will automatically add additional capabilities
--- `$PACKDIR/blink.cmp/lua/blink/cmp/sources/lib/init.lua`
local lsp = vim.lsp
local fn = vim.fn

local enable_servers = function()
  local servers = vim
    .iter(fn.globpath(fn.stdpath('config') .. '/after/lsp', '*', false, true))
    :map(function(path) return fn.fnamemodify(path, ':t:r') end)
    :totable()
  lsp.enable(servers)
end

vim.schedule(enable_servers)

nv.on('LspProgress', {}, function(ev)
  nv.lsp.progress.callback(ev)
  vim.cmd.redrawstatus()
end)

nv.on('LspAttach', {}, function(ev)
  local client = assert(lsp.get_client_by_id(ev.data.client_id))
  if client:supports_method('textDocument/completion') then
    -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
    -- Optional: trigger autocompletion on EVERY keypress. May be slow!
    -- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
    -- client.server_capabilities.completionProvider.triggerCharacters = chars
    -- lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
  end
  if client:supports_method('textDocument/foldingRange') then
    -- local win = vim.api.nvim_get_current_win()
    -- vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
  end
  if client:supports_method('textDocument/implementation') then
    -- Create a keymap for vim.lsp.buf.implementation ...
  end
  -- Auto-format ("lint") on save not needed if server supports
  -- `textDocument/willSaveWaitUntil`.
  if
    not client:supports_method('textDocument/willSaveWaitUntil')
    and client:supports_method('textDocument/formatting')
  then
    -- nv.on('BufWritePre', '*', {
    --   buffer = ev.buf,
    --   callback = function()
    --     lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })
    --   end,
    -- })
  end
end)
