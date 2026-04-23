---@type blink.cmp.Source
local M = {}

function M.new() return setmetatable({}, { __index = M }) end

function M:get_completions(_, callback)
  local items = {}
  for i = 1, 9 do
    local content = vim.fn.getreg(tostring(i))
    local documentation = table.concat({
      '```\n' .. content .. '\n```',
      '',
      '- Press `' .. i .. '` to paste from this register',
    }, '\n')
    items[i] = {
      label = ('[%d] %s'):format(i, vim.trim(content):gsub('\n.*', '')),
      kind = vim.lsp.protocol.CompletionItemKind.Text,
      insertText = content,
      sortText = ('%02d'):format(i),
      insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
      documentation = documentation,
    }
  end
  callback({
    is_incomplete_forward = false,
    is_incomplete_backward = false,
    items = items,
  })
  return function() end
end

return M
