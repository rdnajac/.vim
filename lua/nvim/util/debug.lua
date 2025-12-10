local M = {}

local debug_r = function()
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
  -- local word = vim.fn.expand('<cword>')
  local word = vim.fn.expand('<cWORD>')
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local templates = {
    -- lua = string.format("print('%s = ' .. vim.inspect(%s))", word, word),
    lua = 'print(' .. word .. ')',
    c = string.format('printf("+++ %d %s: %%d\\n", %s);', row, word, word),
    sh = string.format('echo "+++ %d %s: $%s"', row, word, word),
    r = word,
    vim = ([[echom %s]]):format(word),
  }
  if vim.tbl_contains(vim.tbl_keys(templates), ft) then
    vim.api.nvim_buf_set_lines(0, row, row, true, { templates[ft] })
  end
end

M.print = function()
  if vim.bo.filetype == 'r' and package.loaded['r'] then
    return debug_r()
  end
  print_debug()
end

return M
