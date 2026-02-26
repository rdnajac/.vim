---@module "snacks"

local todo = require('nvim.util.todo')

-- Cache the full keyword pattern once (lookup never changes at runtime)
local all_keywords = vim.iter(todo.lookup):map(function(k, _) return k end):join('|')

local match_regex = [[\v\C]] .. ('.*<(%s)\\s*:'):format(all_keywords)

---@param filter? function(k: string):bool
---@return string
local function keywords(filter)
  if not filter then
    return all_keywords
  end
  return vim.iter(todo.lookup):map(function(k, _) return k end):filter(filter):join('|')
end

-- same as `vim.fn.match`, but returns a list
local function match(str)
  local m = vim.fn.matchlist(str, match_regex)
  if #m > 1 and m[2] then
    local kw = m[2]
    local start = str:find(kw, 1, true)
    return start, start + #kw, kw
  end
end

return {
  finder = 'grep',
  live = false,
  supports_live = true,
  search = function(picker)
    local opts = picker.opts or {}
    local filter = opts.keywords and function(k) return vim.tbl_contains(opts.keywords, k) end
    return ([[\b(%s):]]):format(keywords(filter))
  end,
  format = function(item, picker)
    local align = Snacks.picker.util.align
    local ret = {}
    local _, _, kw = match(item.text)
    if kw then
      local text = { align(kw, 6, { align = 'center' }), 'MiniHipatterns' .. todo.lookup[kw] }
      local icon = todo.icon(kw)
      icon[1] = align(icon[1], 2)
      ret = { icon, text, { ' ' } }
    end
    return vim.list_extend(ret, Snacks.picker.format.file(item, picker))
  end,
  -- on_show = function(picker) MiniHipatterns.enable(picker.list.win.buf) end,
}
