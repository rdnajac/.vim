local lsp = vim.lsp
return function(ev) ---@param ev{data:{client_id:number,buf:number}}
  local client = assert(lsp.get_client_by_id(ev.data.client_id))
  -- print('LSP client attached: ' .. client.name)
  -- autocompletion
  if client:supports_method('textDocument/completion') then
    -- Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
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
    -- Create a keymap for lsp.buf.implementation ...
  end
  -- Auto-format ("lint") on save not needed if server supports
  -- `textDocument/willSaveWaitUntil`.
  if
    not client:supports_method('textDocument/willSaveWaitUntil')
    and client:supports_method('textDocument/formatting')
  then
    -- vim.api.nvim.nvi
    -- TODO: create an autocmd on 'BufWritePre',
    --   buffer = ev.buf,
    --   callback = function()
    --     lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })
    --   end,
    -- })
  end
  -- if client:supports_method('textDocument/implementation') then
  -- add more...
end
