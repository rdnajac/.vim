-- TODO: fold all comments
local M = vim.defaulttable(function(k) return require('nvim.util.' .. k) end)

M.gh = function(s) return string.format('https://github.com/%s.git', s) end
M.is_curwin = function() return vim.fn.win_getid() ~= vim.g.statusline_winid end
M.is_nonempty_list = function(v) return vim.islist(v) and #v > 0 end
M.is_nonempty_string = function(v) return type(v) == 'string' and v ~= '' end

--- Get all lines from a buffer
--- @param bufnr number? buffer number, defaults to current buffer
--- @return string[]|{} lines of the buffer, empty list if buffer has no lines
M.get_buf_lines = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local nlines = vim.api.nvim_buf_line_count(bufnr)
  -- NOTE: indexing is zero-based and end-exclusive
  return vim.api.nvim_buf_get_lines(bufnr, 0, nlines, false)
end

---@param line number
---@param col number
---@return string
M.synname = function(line, col) return vim.fn.synIDattr(vim.fn.synID(line, col, 1), 'name') end

--- Convert a file path to a module name by trimming the lua root
--- @param path string file path
--- @return string module name suitable for `require()`
-- HACK: don't convert slashes to dots as `require()` fixes that
M.modname = function(path) return vim.fn.fnamemodify(path, ':r:s?^.*/lua/??') end

--- Deferred redraw after `t` milliseconds (default 200ms)
---@param t number? time in ms to defer
M.defer_redraw_win = function(t)
  vim.defer_fn(function() Snacks.util.redraw(vim.api.nvim_get_current_win()) end, t or 200)
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
