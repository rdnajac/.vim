---@module "snacks"
---@class snacks.picker.todo.Config: snacks.picker.grep.Config
---@field keywords? string[]

local keywords = {
  FIX = { icon = ' ', color = 'error', alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' } },
  TODO = { icon = ' ', color = 'info' },
  HACK = { icon = ' ', color = 'warning' },
  WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
  PERF = { icon = ' ', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
  NOTE = { icon = ' ', color = 'hint', alt = { 'INFO' } },
  TEST = { icon = '⏲ ', color = 'test', alt = { 'TESTING', 'PASSED', 'FAILED' } },
}

local keyword_keys = vim.tbl_keys(keywords)
table.sort(keyword_keys, function(a, b)
  return #b < #a
end)
local search_pattern = ([[\b(%s):]]):format(table.concat(keyword_keys, '|'))

local Highlight = require('todo-comments.highlight')
local align = Snacks.picker.util.align

Snacks.picker.sources.todo = {
  finder = 'grep',
  live = false,
  supports_live = true,
  search = function(picker)
    local opts = picker.opts --[[@as snacks.picker.todo.Config]]
    if not opts.keywords then
      return search_pattern
    end
    local kws = vim.tbl_filter(function(kw)
      return keywords[kw]
    end, opts.keywords)
    table.sort(kws, function(a, b)
      return #b < #a
    end)
    return [[\b(]] .. table.concat(kws, '|') .. [[):]]
  end,
  format = function(item, picker)
    local ret = {}
    local _, _, kw = Highlight.match(item.text)
    if kw then
      local kw_data = keywords[kw]
      local icon = kw_data and kw_data.icon or ''
      ret = {
        { align(icon, 2), 'TodoFg' .. kw },
        { align(kw, 6, { align = 'center' }), 'TodoBg' .. kw },
        { ' ' },
      }
      return vim.list_extend(ret, Snacks.picker.format.file(item, picker))
    end
  end,
  previewer = function(ctx)
    Snacks.picker.preview.file(ctx)
    -- Highlight.highlight_win(ctx.preview.win.win, true)
    -- Highlight.update()
  end,
}

return Snacks.picker.pick('todo')
