-- TODO: fold all comments

-- fn/init.lua
-- build a table from all the files in this dir
-- each file returns a function, so lazily load them by
-- setting a metatable on the module table and the filename is the function
local M = vim.defaulttable(function(k) return require('nvim.util.' .. k) end)

M.ensure_list = function(t) return vim.islist(t) and t or { t } end
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

--- Get list of submodules in a given subdirectory of `nvim/`
---@param subdir string subdirectory of `nvim/` to search
---@return string[] list of module names ready for `require()`
M.submodules = function(subdir)
  local luaroot = vim.fs.joinpath(vim.g.stdpath.config, 'lua')
  local path = vim.fs.joinpath(luaroot, 'nvim', subdir)
  local files = vim.fn.globpath(path, '*.lua', false, true)
  return vim.tbl_map(function(f) return f:sub(#luaroot + 2, -5) end, files)
end

--- Deferred redraw after `t` milliseconds (default 200ms)
---@param t number? time in ms to defer
M.defer_redraw_win = function(t)
  vim.defer_fn(function()
    -- vim.cmd([[redraw!]])
    -- vim.cmd.redraw({ bang = true })
    Snacks.util.redraw(vim.api.nvim_get_current_win())
  end, t or 200)
end

return M
