local luaroot = vim.fs.joinpath(vim.g.stdpath.config, 'lua')

local M = {}

--- Get list of submodules in a given subdirectory of `nvim/`
---@param subdir string subdirectory of `nvim/` to search
---@return string[] list of module names ready for `require()`
M.submodules = function(subdir)
  local path = vim.fs.joinpath(luaroot, 'nvim', subdir)
  local files = vim.fn.globpath(path, '*.lua', false, true)
  return vim.tbl_map(function(f) return f:sub(#luaroot + 2, -5) end, files)
end

return M
