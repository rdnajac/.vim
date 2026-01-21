--- utility functions that cross the LUA-VIMSCRIPT BRIDGE
local M = {}

M.foldtext = function()
  local start = vim.fn.getline(vim.v.foldstart)

  -- if first line of the fold is just an opening brace
  if vim.trim(start) == '{' then
    local next = vim.fn.getline(vim.v.foldstart + 1)
    -- return start .. ' ' .. vim.trim(next) .. ' ...'
    return string.format('%s %s ...', start, vim.trim(next))
  end

  if vim.endswith(start, '{') then
    local end_brace = vim.fn.getline(vim.v.foldend):match('},?$')

    if start:match('{%s*$') and (end_brace == '}' or end_brace == '},') then
      return start .. ' ... ' .. end_brace
    end
  end

  return start
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

return M
