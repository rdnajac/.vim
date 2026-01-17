local M = {}

-- native
M.gh = function(s) return string.format('https://github.com/%s.git', s) end
M.is_nonempty_string = function(v) return type(v) == 'string' and v ~= '' end

-- api
M.get_buf_lines = function(bufnr, start, end_)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  start = start or 0
  end_ = end_ or vim.api.nvim_buf_line_count(bufnr)
  return vim.api.nvim_buf_get_lines(bufnr, 0, nlines, false)
end
M.is_curwin = function() return vim.api.nvim_get_current_win() ~= vim.g.statusline_winid end

-- shared
M.is_nonempty_list = function(v) return vim.islist(v) and #v > 0 end

-- snacks
M.defer_redraw_win = function(t)
  -- vim.defer_fn(function() Snacks.util.redraw(vim.api.nvim_get_current_win()) end, t or 200)
  vim.defer_fn(
    function()
      vim.api.nvim__redraw({ win = vim.api.nvim_get_current_win(), valid = false, flush = false })
    end,
    t or 200
  )
end

M.foldtext = function()
  local start = vim.fn.getline(vim.v.foldstart)
  if vim.trim(start) == '{' then
    local next_line = vim.fn.getline(vim.v.foldstart + 1)
    return start .. ' ' .. vim.trim(next_line) .. ' ...'
  end

  if vim.endswith(start, '{') then
    local end_brace = vim.fn.getline(vim.v.foldend):match('},?$')

    if start:match('{%s*$') and (end_brace == '}' or end_brace == '},') then
      return start .. ' ... ' .. end_brace
    end
  end

  return start
end

return M
