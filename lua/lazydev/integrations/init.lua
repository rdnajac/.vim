local Config = require('lazydev.config')

local M = {}

---@type table<string, boolean>
M.loaded = {}

function M.setup()
  for name, enabled in pairs(Config.integrations) do
    if enabled then
      M.load(name)
    end
  end
end

---@param name string
function M.load(name)
  if not M.loaded[name] then
    M.loaded[name] = true
    require('lazydev.integrations.' .. name).setup()
  end
end

return M
