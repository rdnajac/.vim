local print_debug = function()
  local ft = vim.bo.filetype
  local word = vim.fn.expand('<cword>')
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local templates = {
    -- lua = string.format("print('%s = ' .. vim.inspect(%s))", word, word),
    lua = 'print(' .. word .. ')',
    c = string.format('printf("+++ %d %s: %%d\\n", %s);', row, word, word),
    sh = string.format('echo "+++ %d %s: $%s"', row, word, word),
  }
  local print_line = templates[ft]
  if not print_line then
    return
  end
  vim.api.nvim_buf_set_lines(0, row, row, true, { print_line })
end

return print_debug
