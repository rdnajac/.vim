local M = {}

function M.gen(path, lines)
  lines = vim.list_extend({ '-- This file is generated. Do not edit.' }, lines)
  vim.fn.mkdir(vim.fs.dirname(path), 'p')
  vim.fn.writefile(lines, path)
  vim.notify('File created: ' .. path, vim.log.levels.INFO)
  return path
end

function M.size()
  local fn = vim.fn
  local size = fn.getfsize(fn.expand('%:p'))
  if size == -1 then
    error('file not found')
  elseif size == -2 then
    error('fsize too big')
  end
  local prefixes = { '', 'K', 'M', 'G' }
  local i = 1
  while size > 1024 and i < #prefixes do
    size = size / 1024
    i = i + 1
  end

  local fmt = (i == 1 and '%d bytes' or '%.2f %sib')
  return string.format(fmt, size, prefixes[i])
end

return M
