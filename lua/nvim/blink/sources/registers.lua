---@module 'blink.cmp'

---@class blink.cmp.Source
local source = {}

function source.new(opts)
  local self = setmetatable({}, { __index = source })
  self.opts = opts
  return self
end

---@param ctx table (context) contains the current keyword, cursor position, bufnr, etc.
function source:get_completions(ctx, callback)
  ---@type lsp.CompletionItem[]
  local items = {}
  local registers = { '1', '2', '3', '4', '5', '6', '7', '8', '9', '0' }

  for i, reg in ipairs(registers) do
    local content = vim.fn.getreg(reg)
    if content ~= '' then
      ---@type lsp.CompletionItem
      -- FIXME: appearance
      local item = {
        label = '"' .. reg,
        kind = require('blink.cmp.types').CompletionItemKind.Text,
        filterText = '"' .. reg .. ' ' .. content,
        -- sortText = string.format('%d', i),
        insertText = content,
        insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
        data = { reg = reg },
      }
      table.insert(items, item)
    end
  end

  callback({ items = items, is_incomplete_backward = false, is_incomplete_forward = false })
  return function() end
end

return source
