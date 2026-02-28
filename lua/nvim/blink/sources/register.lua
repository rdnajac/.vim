local fuzzy = require('blink.cmp.fuzzy')

---@diagnostic disable-next-line: unused-local
local api, fn, uv = vim.api, vim.fn, vim.uv

---@module 'blink.cmp'

local function words_to_items(words)
  local items = {}
  for _, word in ipairs(words) do
    table.insert(items, {
      label = word,
      kind = require('blink.cmp.types').CompletionItemKind.Text,
      insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
      insertText = word,
    })
  end
  return items
end

--- @param text string
--- @param callback fun(items: blink.cmp.CompletionItem[])
local function run_sync(text, callback)
  callback(words_to_items(require('blink.cmp.fuzzy').get_words(text)))
end

local function run_async_rust(text, callback)
  local worker = uv.new_work(
    -- must use rust module directly since the normal one requires the config which isnt present
    function(text0, cpath)
      package.cpath = cpath
      ---@diagnostic disable-next-line: redundant-return-value
      return table.concat(require('blink.cmp.fuzzy.rust').get_words(text0), '\n')
    end,
    function(words)
      local items = words_to_items(vim.split(words, '\n'))
      vim.schedule(function() callback(items) end)
    end
  )
  worker:queue(text, package.cpath)
end

local function run_async_lua(text, callback)
  local min_chunk_size = 2000 -- Min chunk size in bytes
  local max_chunk_size = 4000 -- Max chunk size in bytes
  local total_length = #text

  local cancelled = false
  local pos = 1
  local all_words = {}

  local function next_chunk()
    if cancelled then
      return
    end

    local start_pos = pos
    local end_pos = math.min(start_pos + min_chunk_size - 1, total_length)

    -- Ensure we don't break in the middle of a word
    if end_pos < total_length then
      while
        end_pos < total_length
        and (end_pos - start_pos) < max_chunk_size
        and not string.match(string.sub(text, end_pos, end_pos), '%s')
      do
        end_pos = end_pos + 1
      end
    end

    pos = end_pos + 1

    local chunk_text = string.sub(text, start_pos, end_pos)
    local chunk_words = require('blink.cmp.fuzzy').get_words(chunk_text)
    vim.list_extend(all_words, chunk_words)

    -- next iter
    if pos < total_length then
      return vim.schedule(next_chunk)
    end

    -- Deduplicate and finish
    local words = require('blink.cmp.lib.utils').deduplicate(all_words)
    vim.schedule(function() callback(words_to_items(words)) end)
  end

  next_chunk()

  return function() cancelled = true end
end

--- @class blink.cmp.RegisterOpt
--- @field get_registers fun(): string
--- @field max_sync_size integer Maximum buffer text size for sync processing
--- @field max_async_size integer Maximum buffer text size for async processing

--- Public API

local M = {}

function M.new(opts)
  local self = setmetatable({}, { __index = M })

  --- @type blink.cmp.RegisterOpt
  opts = vim.tbl_deep_extend('keep', opts or {}, {
    get_registers = function()
      return [[abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"=*+]]
    end,
    max_sync_size = 20000,
    max_async_size = 500000,
  })
  require('blink.cmp.config.utils').validate('sources.providers.buffer', {
    max_sync_size = { opts.max_sync_size, 'number' },
    max_async_size = { opts.max_async_size, 'number' },
  }, opts)

  self.opts = opts
  return self
end

function M:get_completions(_, callback)
  local transformed_callback = function(items)
    callback({ is_incomplete_forward = false, is_incomplete_backward = false, items = items })
  end

  vim.schedule(function()
    local texts = {}
    for r in self.opts.get_registers():gmatch('.') do
      table.insert(texts, fn.getreg(r))
    end
    local text = table.concat(texts, '\n')

    -- should take less than 2ms
    if #text < self.opts.max_sync_size then
      run_sync(text, transformed_callback)
    -- should take less than 10ms
    elseif #text < self.opts.max_async_size then
      if fuzzy.implementation_type == 'rust' then
        return run_async_rust(text, transformed_callback)
      else
        ---@diagnostic disable-next-line: redundant-return-value
        return run_async_lua(text, transformed_callback)
      end
    -- too big so ignore
    else
      transformed_callback({})
    end
  end)
end

return M
