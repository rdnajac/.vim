-- meta/test.lua
-- TODO: try mini.test
local M = {}

local modname = require('meta').modname

--- Run test cases
M.modname = function()
  local eq = function(actual, expected)
    assert(actual == expected, string.format('Expected %q but got %q', expected, actual))
  end
  -- Typical case
  eq(modname('~/dev/nvim/lua/foo/bar.lua'), 'foo.bar')
  -- init.lua in a submodule
  eq(modname('/Users/me/dev/nvim/lua/foo/init.lua'), 'foo')
  -- deeply nested path
  eq(modname('/Users/me/dev/nvim/lua/foo/bar/baz/qux.lua'), 'foo.bar.baz.qux')
  -- init.lua deep
  eq(modname('/Users/me/dev/nvim/lua/foo/bar/init.lua'), 'foo.bar')
  -- non-lua file should fail
  eq(modname('/Users/me/dev/nvim/lua/foo/bar.txt'), nil)
  -- missing /lua/ — returns nil
  eq(modname('/Users/me/dev/foo/bar.lua'), nil)
  print('All tests passed!')
end

M.safe_require = function()
  local safe_require = require('meta').safe_require
  -- Successful require
  local mod = safe_require('math')
  assert(mod ~= nil, 'Expected math module to be loaded')

  -- Failed require with warning
  local mod_fail = safe_require('non_existent_module')
  assert(mod_fail == nil, 'Expected nil for non-existent module')

  -- bail on failure
  -- safe_require('non_existent_module', true) -- should error
  print('safe_require tests passed!')
end

M.run = function()
  -- M.modname()
  M.safe_require()
end

M.run()

return M
