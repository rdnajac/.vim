local M = {}

--- Require a module with optional error suppression.
---@param modname string
---@param errexit? boolean If true, returns nil and prints on failure.
---@return any
function M.safe(modname, errexit)
  local ok, mod = pcall(require, modname)
  if not ok then
    local msg = ('Error requiring "%s": %s'):format(modname, mod)
    if errexit == true then
      error(msg, 2)
    end
    vim.schedule(function()
      vim.notify(msg, vim.log.levels.WARN, { title = 'safe_require' })
    end)
    return nil
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
