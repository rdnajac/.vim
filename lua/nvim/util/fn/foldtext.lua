return function()
  local start_line = vim.fn.getline(vim.v.foldstart)
  local end_line = vim.fn.getline(vim.v.foldend)

  if vim.trim(start_line) == '{' then
    local next_line = vim.fn.getline(vim.v.foldstart + 1)
    return start_line .. ' ' .. vim.trim(next_line) .. ' ...'
  end

  if vim.endswith(start_line, '{') then
    local end_brace = end_line:match('},?$')

    if start_line:match('{%s*$') and (end_brace == '}' or end_brace == '},') then
      return start_line .. ' ... ' .. end_brace
    end
  end

  return start_line
end
