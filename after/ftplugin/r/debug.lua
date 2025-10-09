if not package.loaded['r'] then
  return
end

local debug_word = function()
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

vim.keymap.set('n', '<C-CR>', debug_word, { buffer = true, desc = 'Debug <cword>' })
