-- automagically load plugin modules in this directory
local M = require('meta').module()

local plug = require('plug')

---@type vim.pack.Spec[]
local specs = plug.collect_specs(M)

-- call `vim.pack.add` once with all specs to optimize startup time
-- it clones missing plugins in parallel and add all plugins to rtp
-- TODO: we don't need to force a single call
vim.pack.add(specs)

-- Run config callbacks for all plugins
plug.do_configs(M)

return M
