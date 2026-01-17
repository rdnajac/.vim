--- utility functions that cross the LUA-VIMSCRIPT BRIDGE
local M = {}

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
