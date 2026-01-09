local Plugin = require('plug.plugin')
local Util = require('plug.util')

local M = { keys = {}, toggles = {}, specs = {} }

function M.plug(t)
  local plugin = Plugin.new(t)

  if not plugin.enabled then
    return
  end
  M[plugin.name] = plugin
  M.keys[plugin.name] = plugin.keys
  if plugin.toggles then
    M.toggles = vim.tbl_deep_extend('force', M.toggles, Util.get(plugin.toggles))
  end
  table.insert(M.specs, plugin:tospec())

  return plugin
end

function M.get_keys() return vim.tbl_map(Util.get, vim.tbl_values(M.keys)) end

---@param plug_data {spec: vim.pack.Spec, path: string}
function M.load(plug_data)
  local spec = plug_data.spec
  vim.cmd.packadd({ spec.name, bang = true, magic = { file = false } })
  if spec.data and vim.is_callable(spec.data.setup) then
    spec.data.setup()
  end
end

return setmetatable(M, {
  __call = function(_, t) return M.plug(t) end,
  -- TODO: __index should access the plugins table
  -- __index = function(t, k)
  -- if k == 'keys' then return
  -- end
})
