local M = {}

local debug_r = function()
  if not package.loaded['r'] then
    return
  end
  local word = vim.fn.expand('<cword>')
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  -- copy the <cword> to a new line below the current line
  vim.api.nvim_buf_set_lines(0, row, row, true, { word })
  -- move cursor to the new line
  vim.api.nvim_win_set_cursor(0, { row + 1, 0 })
  -- execute <Plug>RInsertLineOutput from normal mode
  vim.api.nvim_feedkeys(vim.keycode('<Plug>RInsertLineOutput'), 'n', false)
  -- delete the line with the word
  vim.api.nvim_buf_set_lines(0, row, row + 1, true, {})
  -- move cursor back to original position
  vim.api.nvim_win_set_cursor(0, { row, col })
end

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

M.print = function()
  if vim.bo.filetype == 'r' then
    debug_r()
  else
    print_debug()
  end
end

return M
