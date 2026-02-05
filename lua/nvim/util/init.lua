local M = vim.defaulttable(function(k) return require('nvim.util.' .. k) end)

-- native
M.gh = function(s) return string.format('https://github.com/%s.git', s) end
M.is_nonempty_string = function(v) return type(v) == 'string' and v ~= '' end

-- api
M.get_buf_lines = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local nlines = vim.api.nvim_buf_line_count(bufnr)
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

--- foldtext for lua files with treesitter folds
---@returns string
M.foldtext = function()
  local indicator = '...'
  local start = vim.fn.getline(vim.v.foldstart)
  local end_ = vim.fn.getline(vim.v.foldend)
  local parts = { start }

  if vim.endswith(start, '{') then
    if vim.trim(start) == '{' then -- only '{' on the line
      local second_line = vim.fn.getline(vim.v.foldstart + 1)
      local quoted_str = second_line:match('^%s*(["\']..-["\'],?)%s*$')
      parts[#parts + 1] = quoted_str
    end
    parts[#parts + 1] = indicator
  elseif vim.endswith(start, ')') or vim.endswith(start, 'do') then
    parts[#parts + 1] = indicator
  else
    return start -- return if no special handling
  end
  parts[#parts + 1] = vim.trim(end_)
  return table.concat(parts, ' ')
end

-- count keys used in all subtables of M
M.key_counts = function()
  local ret = {}
  for _, v in pairs(M) do
    if
      type(v) == 'table' --[[and v ~= M.key_counts]]
    then
      for key in pairs(v) do
        ret[key] = (ret[key] or 0) + 1
      end
    end
  end
  return ret
end

--- Check if the current position is inside a comment
---@return boolean
M.is_comment = function(opts)
  local ok, node = pcall(vim.treesitter.get_node, opts)
  if ok and node then
    return nv.treesitter.node_is_comment(node)
  end
  return vim.fn['is#comment']()
end

return M
