local M = {}

--- Converts a file path to a Lua module name.
---@param path string
---@return string|nil
M.modname = function(path)
  local sep = package.config:sub(1, 1)
  local lua_root = path:find(sep .. 'lua' .. sep, 1, true)
  local is_lua_file = path:match('%.lua$')
  local is_directory = vim.fn.isdirectory(path) == 1

  if lua_root and (is_lua_file or is_directory) then
    return (
      path
        :sub(lua_root + #('/lua' .. sep)) -- remove leading /lua/
        :gsub('%.lua$', '') -- strip .lua
        :gsub(sep, '.') -- convert path sep
        :gsub('^%.', '') -- strip leading dot
        :gsub('%.init$', '') -- strip .init
        :gsub('%.$', '') -- strip trailing dot
    )
  end
end

return M
