-- https://github.com/bydlw98/blink-cmp-env
--- @module 'blink.cmp'

local async = require('blink.cmp.lib.async')
local types = require('blink.cmp.types')

--- @class EnvSource : blink.cmp.Source
--- @field cached_results boolean
--- @field completion_items blink.cmp.CompletionItem[]
local M = {}

--- @return EnvSource
function M.new()
  local self = setmetatable({}, { __index = M })
  self.cached_results = false
  self.completion_items = {}
  return self
end

function M:get_trigger_characters() return { '$' } end

--- Include the trigger character when accepting a completion.
--- @param items blink.cmp.CompletionItem[]
--- @param ctx blink.cmp.Context
local function transform(items, ctx)
  return vim.tbl_map(function(entry) ---@param entry blink.cmp.CompletionItem
    return entry.kind == types.CompletionItemKind.Snippet and entry
      or vim.tbl_deep_extend('force', entry, {
        textEdit = {
          range = {
            start = { line = ctx.cursor[1] - 1, character = ctx.bounds.start_col - 2 },
            ['end'] = { line = ctx.cursor[1] - 1, character = ctx.cursor[2] },
          },
        },
      })
  end, items)
end

--- @param ctx blink.cmp.Context
--- @param callback fun(...: any)
--- @return fun()
function M:get_completions(ctx, callback)
  local task = async.task.empty():map(function()
    local trigger_chars = self:get_trigger_characters()
    local start_col = ctx.bounds.start_col

    --- @cast start_col integer
    local cursor_first_char = ctx.line:sub(start_col - 1, start_col - 1)

    if vim.list_contains(trigger_chars, cursor_first_char) then
      if not self.cached_results then
        self:setup_completion_items()
        self.cached_results = true
      end

      callback({
        is_incomplete_forward = false,
        is_incomplete_backward = false,
        items = transform(self.completion_items, ctx),
      })
    else
      callback()
    end

    return function() end
  end)

  return function() task:cancel() end
end

--- Get a dictionary with environment variables and their respective values
function M:setup_completion_items()
  for key, value in pairs(vim.fn.environ()) do
    key = '$' .. key
    local doc = { kind = 'markdown', value = ('## `%s`\n```sh\n%s```'):format(key, value) }

    table.insert(self.completion_items, {
      label = key,
      insertText = key,
      insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
      kind = require('blink.cmp.types').CompletionItemKind.Variable,
      documentation = doc,
      textEdit = { newText = key },
    })

    table.insert(self.completion_items, {
      label = key,
      insertText = value,
      insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
      kind = require('blink.cmp.types').CompletionItemKind.Snippet,
      documentation = doc,
    })
  end
end

return M
