---@module "snacks"
-- TODO: resolve with mini hipatterns config

local keywords = {
  FIX = { icon = ' ', color = 'error', alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' } },
  TODO = { icon = ' ', color = 'info' },
  HACK = { icon = ' ', color = 'warning' },
  WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
  PERF = { icon = ' ', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
  -- NOTE = { icon = ' ', color = 'hint', alt = { 'INFO' } },
  -- TEST = { icon = '⏲ ', color = 'test', alt = { 'TESTING', 'PASSED', 'FAILED' } },
}
-- keywords.Section = { icon = '󰚟', color = 'title' }

local colors = {
  title = { '#7DCFFF' },
  error = { '#DC2626' },
  warning = { 'DiagnosticWarn', 'WarningMsg', '#FBBF24' },
  info = { 'DiagnosticInfo', '#2563EB' },
  hint = { 'DiagnosticHint', '#10B981' },
  default = { 'Identifier', '#7C3AED' },
  test = { 'Identifier', '#FF00FF' },
}

-- TODO: generate dynamically
local regex = '.*<(WARN|FIXME|TODO||WARN|PERF|HACK|BUG|XXX)\\s*:'

local match = function(str)
  -- same as `vim.fn.match`, but returns a list
  local m = vim.fn.matchlist(str, [[\v\C]] .. regex)
  -- if nv.is_nonempty_list(m) then
  if #m > 1 and m[2] then
    local match = m[2]
    local kw = m[3] ~= '' and m[3] or m[2]
    local start = str:find(match, 1, true)
    return start, start + #match, kw
  end
end

return {
  finder = 'grep',
  live = false,
  supports_live = true,
  ---@param picker { opts: { keywords: string[] } }
  search = function(picker)
    local opts = picker.opts
    local kws = vim
      .iter(vim.tbl_keys(keywords))
      :filter(function(kw) return opts.keywords and vim.tbl_contains(opts.keywords, kw) or true end)
      :totable()
    table.sort(keywords, function(a, b) return #b < #a end)
    return ([[\b(%s):]]):format(table.concat(kws, '|'))
  end,
  format = function(item, picker)
    local align = Snacks.picker.util.align
    local ret = {}
    local _, _, kw = match(item.text)
    if kw then
      local kw_data = keywords[kw]
      local icon = kw_data and kw_data.icon or ''
      -- TODO: don't hardcode hl groups; use `mini.hl`
      ret = {
        -- { align(icon, 2), 'TodoFg' .. kw },
        { align(icon, 2) },
        -- { align(kw, 6, { align = 'center' }), 'TodoBg' .. kw },
        { align(kw, 6, { align = 'center' }) },
        { ' ' },
      }
    end
    return vim.list_extend(ret, Snacks.picker.format.file(item, picker))
  end,
}
