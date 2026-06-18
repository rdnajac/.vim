local M = {}

function M.gen_file(path, lines)
  lines = vim.list_extend({ '-- This file is generated. Do not edit.' }, lines)
  vim.fn.mkdir(vim.fs.dirname(path), 'p')
  vim.fn.writefile(lines, path)
  vim.notify('File created: ' .. path, vim.log.levels.INFO)
  return path
end

return M
