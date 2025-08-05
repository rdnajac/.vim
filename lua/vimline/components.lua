-- Escape `%` in str so it doesn't get picked as stl item.
local vimlineescape = function(str)
  return type(str) == 'string' and str:gsub('%%', '%%%%') or str
end

local M = {}

M.hostname = function()
  vimlineescape(vim.loop.os_gethostname())
end

M.location = function()
  local line = vim.fn.line('.')
  local col = vim.fn.charcol('.')
  return string.format('%3d:%-2d', line, col)
end

M.searchcount = function()
  local ok, r = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 500 })
  return (vim.v.hlsearch == 0 or not ok or not r or next(r) == nil) and ''
    or ('[' .. r.current .. '/' .. math.min(r.total, r.maxcount) .. ']')
end

M.selectioncount = function()
  local mode = vim.fn.mode(true)
  local line_start, col_start = vim.fn.line('v'), vim.fn.col('v')
  local line_end, col_end = vim.fn.line('.'), vim.fn.col('.')
  if mode:match('') then
    return string.format('%dx%d', math.abs(line_start - line_end) + 1, math.abs(col_start - col_end) + 1)
  elseif mode:match('V') or line_start ~= line_end then
    return math.abs(line_start - line_end) + 1
  elseif mode:match('v') then
    return math.abs(col_start - col_end) + 1
  else
    return ''
  end
end

return M
