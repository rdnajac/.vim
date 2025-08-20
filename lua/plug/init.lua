local Plug = N.plug

---@type table<string, any>
local M = setmetatable({}, {
  __newindex = function(t, key, value)
    local plug_spec = Plug(value)
    rawset(t, key, plug_spec)
  end,
})

local dir = 'plug/'

-- load all modules from the directory
require('util').for_each_module(function(plugin)
  local name = plugin:sub(#dir + 1)
  M[name] = plugin -- automatically calls Plug via __newindex
end, dir)

-- run configs on all plugged plugins
Plug.do_configs(M)

return M
