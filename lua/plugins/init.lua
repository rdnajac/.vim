local plug = require('nvim.plug')

---@type table<string, PlugSpec>
local M = require('meta.module').new():load()

---@type vim.pack.Spec[]
local specs = plug.collect_specs(M)

-- call `vim.pack.add` once with all specs to optimize startup time
-- it clones missing plugins in parallel and add all plugins to rtp
vim.pack.add(specs)

-- do configs for all plugins a la `lazy.nvim`
for name, plugin in pairs(M) do
  if plug.is_enabled(plugin) then
    -- TODO: is this the best spot for build?
    -- plug.build(name, plugin)
    plug.config(name, plugin)
  end
end

plug.do_configs()

return M
