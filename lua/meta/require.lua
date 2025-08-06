local M = {}

--- Require a module with optional error suppression.
---@param modname string
---@param bail? boolean @If false, returns nil and prints on failure.
---@return any
function M.safe(modname, bail)
  local ok, mod = pcall(require, modname)
  if not ok then
    local msg = ('Error requiring "%s": %s'):format(modname, mod)
    if bail == false then
      vim.schedule(function()
        vim.notify(msg, vim.log.levels.WARN, { title = 'meta.require' })
      end)
      return nil
    end
    error(msg, 2)
  end
  return mod
end

--- Lazily load a table of modules.
---@param modules table<string, string>  -- key = export name, value = module name
---@param bail? boolean
---@return table<string, any>
function M.lazy(modules, bail)
  return setmetatable({}, {
    __index = function(self, key)
      local modname = modules[key]
      if not modname then
        return nil
      end

      local mod = M.require(modname, bail)
      if mod ~= nil then
        rawset(self, key, mod)
        return mod
      end
    end,
  })
end

return M
