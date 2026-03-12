local M = setmetatable({}, {
  __call = function(M, ...) return M.printval(...) end,
})

M.printval = function()
  local ft = vim.bo.filetype
  -- stylua: ignore
  if ft == 'r' and package.loaded['r'] then return debug_r() end

  local row = vim.api.nvim_win_get_cursor(0)[1]
  local word = vim.fn.expand('<cWORD>'):gsub(',$', '') -- trim trailing comma
  local templates = {
    -- lua = 'print(' .. word .. ')',
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

return M
