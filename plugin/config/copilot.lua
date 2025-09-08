vim.keymap.set('i', '<M-CR>', function()
  local bufnr = vim.api.nvim_get_current_buf()
  local client = vim.lsp.get_clients({ bufnr = bufnr, name = 'copilot' })[1]
  if not client then
    vim.notify('Copilot LSP not active', vim.log.levels.WARN)
    return
  end

  ---@class lsp.TextDocumentPositionParams
  local params = vim.lsp.util.make_position_params()
  params.context = { triggerKind = 2 }

  client:request('textDocument/inlineCompletion', params, function(err, result)
    if err then
      vim.notify('Copilot error: ' .. err.message, vim.log.levels.ERROR)
      return
    end
    if not result or not result.items or vim.tbl_isempty(result.items) then
      vim.notify('No Copilot completions', vim.log.levels.INFO)
      return
    end

    -- Take the first suggestion
    local item = result.items[1]
    local text = item.insertText or (item.textEdit and item.textEdit.newText)

    if text then
      -- apply the suggestion at cursor
      local row, col = unpack(vim.api.nvim_win_get_cursor(0))
      vim.api.nvim_buf_set_text(bufnr, row - 1, col, row - 1, col, vim.split(text, '\n'))
    else
      vim.notify('No insertable text from Copilot', vim.log.levels.WARN)
    end
  end, bufnr)
end, { buffer = 0, desc = 'Copilot: inline completion' })
