return function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local nlines = vim.api.nvim_buf_line_count(bufnr)
  -- NOTE: indexing is zero-based and end-exclusive
  return vim.api.nvim_buf_get_lines(bufnr, 0, nlines, false)
end
