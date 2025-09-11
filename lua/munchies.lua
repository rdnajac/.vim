local M = {}

local mod_timer = assert(vim.uv.new_timer())
local mod_cb = {} ---@type table<string, fun(modname:string)[]>

---@return boolean waiting
local function mod_check()
  for modname, cbs in pairs(mod_cb) do
    if package.loaded[modname] then
      mod_cb[modname] = nil
      for _, cb in ipairs(cbs) do
        cb(modname)
      end
    end
  end
  return next(mod_cb) ~= nil
end

--- Call a function when a module is loaded.
--- The callback is called immediately if the module is already loaded.
--- Otherwise, it is called when the module is loaded.
---@param modname string
---@param cb fun(modname:string)
function M.on_module(modname, cb)
  mod_cb[modname] = mod_cb[modname] or {}
  table.insert(mod_cb[modname], cb)
  if mod_check() then
    mod_timer:start(
      100,
      100,
      vim.schedule_wrap(function()
        return not mod_check() and mod_timer:stop()
      end)
    )
  end
end

return M
