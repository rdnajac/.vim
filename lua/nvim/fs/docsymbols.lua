---@param params { textDocument: { uri: string } }
---@param callback function
methods['textDocument/documentSymbol'] = function(params, callback)
  local bufnr = vim.uri_to_bufnr(params.textDocument.uri)
  local files = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local symbols = vim
    .iter(files)
    :enumerate() -- yields index, value
    :map(function(i, line) return vim.trim(line), i end)
    :filter(function(line, _) return line ~= '' end)
    :map(function(line, i)
      local name = vim.fs.basename(line)
      local kind = vim.endswith(name, '/') and vim.lsp.protocol.SymbolKind.Namespace
        or vim.lsp.protocol.SymbolKind.File
      local range = {
        start = { line = i - 1, character = 0 },
        ['end'] = { line = i - 1, character = 0 },
      }
      return { name = name, kind = kind, range = range, selectionRange = range }
    end)
    :totable()
  callback(nil, symbols)
end
