local M = {}

--- Converts a file path to a Lua module name.
---@param path string The file path to convert.
---@return string
M.modname = function(path)
  local lua_start = path:find('/lua/')
  if not lua_start then
    return path
  end

  local mod_path = path:sub(lua_start + #'/lua/')
  local ret = mod_path
    :gsub('%.lua$', '') -- remove '.lua' extension
    :gsub('/', '.') -- convert path to module format
    :gsub('^%.', '') -- remove leading dot
    :gsub('%.init$', '') -- optionally remove '.init' suffix for init.lua
  return ret
end

return M
