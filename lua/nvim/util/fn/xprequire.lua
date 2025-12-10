local M = setmetatable({}, {
  __call = function(M, ...)
    return M.xprequire(...)
  end,
})

--- Same as require but handles errors gracefully
---
--- @param module string
--- @param errexit? boolean
--- @return any?
M.xprequire = function(module, errexit)
  local ok, mod = xpcall(require, debug.traceback, module)
  if not ok then
    if errexit ~= false then
      local msg = ('Error loading module %s:\n%s'):format(module, mod)
      vim.schedule(function()
        if errexit == true then
          error(msg)
        else
          vim.notify(msg, vim.log.levels.ERROR)
        end
      end)
    end
    return nil
  end
  return mod
end

-- local original_require = require
-- local verbose_require = function(modname)
--   print(([[require('%s')]]):format(modname))
--   return original_require(modname)
-- end
-- require = verbose_require

return M
