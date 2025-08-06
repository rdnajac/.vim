local M = {}

--- Converts a file path to a Lua module name.
---@param path string
---@return string|nil
M.modname = function(path)
  local lua_root = path:find('/lua/', 1, true)
  local is_lua_file = path:match('%.lua$')
  local is_directory = vim.fn.isdirectory(path) == 1

  if lua_root and (is_lua_file or is_directory) then
    return (
      path
        :sub(lua_root + #'/lua/') -- remove leading /lua/
        :gsub('%.lua$', '') -- remove trailing .lua
        :gsub('/', '.') -- convert path separators to module name
        :gsub('^%.', '') -- remove leading dot, if any
        :gsub('%.init$', '') -- strip trailing .init
        :gsub('%.$', '') -- remove trailing .lua
    )
  end
end

--- Run test cases
M.test = function()
  local eq = function(actual, expected)
    assert(actual == expected, string.format('Expected %q but got %q', expected, actual))
  end

  -- Typical case
  eq(M.modname('~/dev/nvim/lua/foo/bar.lua'), 'foo.bar')

  -- init.lua in a submodule
  eq(M.modname('/Users/me/dev/nvim/lua/foo/init.lua'), 'foo')

  -- deeply nested path
  eq(M.modname('/Users/me/dev/nvim/lua/foo/bar/baz/qux.lua'), 'foo.bar.baz.qux')

  -- init.lua deep
  eq(M.modname('/Users/me/dev/nvim/lua/foo/bar/init.lua'), 'foo.bar')

  -- non-lua file should fail
  eq(M.modname('/Users/me/dev/nvim/lua/foo/bar.txt'), nil)

  -- missing /lua/ — returns nil
  eq(M.modname('/Users/me/dev/foo/bar.lua'), nil)

  print('All tests passed!')
end

return M
