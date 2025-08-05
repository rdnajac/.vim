local plug = require('nvim.plug')

---@type table<string, PlugSpec>
local M = require('meta.module').new():load()

---@type vim.pack.Spec[]
local specs = plug.collect_specs(M)

-- call `vim.pack.add` once with all specs to optimize startup time
-- it clones missing plugins in parallel and add all plugins to rtp
vim.pack.add(specs)

plug.do_configs(M)

return M
