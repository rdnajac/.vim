local sep = package.config:sub(1, 1)
local lua_segment = sep .. 'lua' .. sep
local lua_seg_len = #lua_segment

--- Converts a file path to a Lua module name.
---@param path string
---@return string|nil
local M = function(path)
  local lua_root = path:find(lua_segment, 1, true)
  local isluafile = path:match('%.lua$')

  if lua_root and (isluafile or vim.fn.isdirectory(path)) then
    return (
      path
        :sub(lua_root + lua_seg_len) -- remove leading /lua/
        :gsub('%.lua$', '') -- strip .lua
        :gsub(sep, '.') -- convert path sep
        :gsub('^%.', '') -- strip leading dot
        :gsub('%.init$', '') -- strip .init
        :gsub('%.$', '') -- strip trailing dot
    )
  end
end

return M
