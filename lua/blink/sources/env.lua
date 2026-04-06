-- https://github.com/bydlw98/blink-cmp-env
local async = require('blink.cmp.lib.async')
local types = require('blink.cmp.types')

---@type blink.cmp.Source
local M = {}

---@return blink.cmp.Source
function M.new() return setmetatable({}, { __index = M }) end

---@return string[]
function M:get_trigger_characters() return { '$' } end

--- uses `iter:fold` with an empty accumulator to refresh the cache
---@return blink.cmp.CompletionItem[]
local function get_environ()
  local env = vim.fn.environ()
  return vim.iter(env):fold({}, function(acc, key, v)
    key = '$' .. key
    local lines = table.concat({ '## ' .. key, '```sh', v, '```' }, '\n')
    local documentation = { kind = 'markdown', value = lines }
    return vim.list_extend(acc, {
      {
        label = key,
        insertText = key,
        insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
        kind = types.CompletionItemKind.Variable,
        documentation = documentation,
        textEdit = { newText = key },
      },
      {
        label = key,
        insertText = v,
        insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
        kind = types.CompletionItemKind.Snippet,
        documentation = documentation,
      },
    })
  end)
end

---@type blink.cmp.CompletionItem[]
local environ_cache

--- refresh the cache at most once every 100s
local refresh_cache = Snacks.util.throttle(
  function() environ_cache = get_environ() end,
  { ms = 1e5 }
)

--- include the trigger character when accepting a completion
---@param items blink.cmp.CompletionItem[]
---@param ctx blink.cmp.Context
local function transform(items, ctx)
  return vim.tbl_map(
    function(entry)
      return entry.kind == types.CompletionItemKind.Snippet and entry
        or vim.tbl_deep_extend('force', entry, {
          textEdit = {
            range = {
              start = { line = ctx.cursor[1] - 1, character = ctx.bounds.start_col - 2 },
              ['end'] = { line = ctx.cursor[1] - 1, character = ctx.cursor[2] },
            },
          },
        })
    end,
    items
  )
end

---@param ctx blink.cmp.Context
---@param callback fun(...: any)
---@return fun()
function M:get_completions(ctx, callback)
  refresh_cache()
  local task = async.task.empty():map(function()
    local start = ctx.bounds.start_col - 1
    if ctx.line:sub(start, start) == '$' then
      callback({
        is_incomplete_forward = false,
        is_incomplete_backward = false,
        items = transform(environ_cache, ctx),
      })
    else
      callback()
    end
    return function() end
  end)
  return function() task:cancel() end
end

return M
