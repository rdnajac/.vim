local ns = vim.api.nvim_create_namespace('src')

local function highlight_backticks(bufnr)
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for lnum, line in ipairs(lines) do
    for start_col, text in line:gmatch('()`([^`]+)`()') do
      local s_col = start_col - 1
      local e_col = s_col + #text + 2 -- include backticks

      -- only add `extmark` if inside a comment node
      if nv.treesitter.in_comment_node({ lnum - 1, s_col }) then
        vim.api.nvim_buf_set_extmark(bufnr, ns, lnum - 1, s_col, {
          end_col = e_col,
          hl_group = 'Chromatophore',
          hl_mode = 'combine',
          -- conceal = '`',
          spell = false,
        })
      end
    end
  end
end

vim.api.nvim_create_autocmd({ 'BufEnter', 'TextChanged', 'TextChangedI' }, {
  callback = function(args)
    if vim.bo.filetype ~= 'bigfile' then
      highlight_backticks(args.buf)
    end
  end,
})
