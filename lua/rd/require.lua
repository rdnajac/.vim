-- override the default require function to log module loading
local original_require = require
require = function(modname)
  local msg = ('[require] ' .. modname)
  vim.notify(msg, vim.log.levels.INFO, {
    hide_from_history = true,
  })
  return original_require(modname)
end

local original_require = require

setmetatable(package.loaded, {
  __index = function(t, mod)
    print("[first require] " .. mod)
    local r = original_require(mod)
    rawset(t, mod, r)
    return r
  end,
})

require = function(mod) return original_require(mod) end

