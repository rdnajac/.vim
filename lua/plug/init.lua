local Plug = N.plug

---@type table<string, PlugSpec>
local M = {}
-- local M = setmetatable({}, {
--   __newindex = function(t, key, value)
--     print('Adding plugin:', key)
--
--     rawset(t, key, value)
--   end,
-- })

local dir = 'plug/'

require('util').for_each_module(function(plugin)
  M[plugin:sub(#dir + 1)] = Plug(plugin)
end, dir)

Plug.do_configs(M)

return M
