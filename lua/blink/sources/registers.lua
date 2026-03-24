---@type blink.cmp.Source
local M = {}

function M.new() return setmetatable({}, { __index = M }) end

function M:get_completions(_, callback)
  local kind = require('blink.cmp.types').CompletionItemKind.Text
  local items = {}
  for i = 1, 9 do
    local content = vim.fn.getreg(tostring(i))
    items[#items + 1] = {
      label = '"' .. i .. ' ' .. vim.trim(content:gsub('\n', '↵')),
      insertText = content,
      kind = kind,
    }
  end
  callback({ is_incomplete_forward = false, is_incomplete_backward = false, items = items })
  return function() end
end

return M
