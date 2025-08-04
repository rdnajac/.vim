local M = {}

--- Converts a file path to a Lua module name.
---@param path? string The file path to convert.
---@return string
M.modname = function(path)
  local modpath = path or vim.api.nvim_buf_get_name(0)

  local lua_start = modpath:find('/lua/')
  if not lua_start then
    Snacks.notify.warn('Path does not contain "/lua/": ' .. modpath)
    return ''
  end

  return modpath
    :sub(lua_start + #'/lua/')
    :gsub('%.lua$', '') -- remove '.lua' extension
    :gsub('/', '.') -- convert path to module format
    :gsub('^%.', '') -- remove leading dot
    :gsub('%.init$', '') -- optionally remove '.init' suffix for init.lua
end

return M
