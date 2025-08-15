-- pack/vimfect/start/vimline.nvim/lua/vimline/components/init.lua
-- Escape `%` in str so it doesn't get picked as stl item.
local vimlineescape = function(str)
  return type(str) == 'string' and str:gsub('%%', '%%%%') or str
end

local M = {}

--- Blink statusline component
M.blink = function()
  local source_icons = require('nvim.icons').blink_src

  if not package.loaded['blink.cmp.sources.lib'] then
    return ''
  end

  local ok, sources = pcall(require, 'blink.cmp.sources.lib')
  if not ok then
    vim.notify('blink.cmp.sources.lib not found', vim.log.levels.ERROR)
    return ''
  end

  local enabled = sources.get_enabled_providers('default')
  local out = {}

  for name in pairs(sources.get_all_providers()) do
    local icon = source_icons[name] or icons.kinds[name:sub(1, 1):upper() .. name:sub(2)] or ''
    if enabled[name] then
      table.insert(out, icon)
    end
  end

  return table.concat(out, ' ')
end

M.hostname = function()
  vimlineescape(vim.loop.os_gethostname())
end

M.location = function()
  local line = vim.fn.line('.')
  local col = vim.fn.charcol('.')
  return string.format('%3d:%-2d', line, col)
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
