local M = {}

local path = function()
  return (
    LazyVim.lualine.pretty_path({
      relative = 'root',
      modified_sign = '',
      length = 6,
      modified_hl = '',
      directory_hl = '',
      filename_hl = '',
    })()
  )
end

M.insert = function()
  local file = path():gsub('^lua/', '')
  local line_nr = vim.fn.line('.')
  local print_stmt = line_nr == 1 and string.format("ddd('%s')", file)
    or string.format("ddd('%s: %d')", file, line_nr + 1)
  vim.cmd('normal! ' .. (line_nr == 1 and 'O' or 'o') .. print_stmt)
end

return M
