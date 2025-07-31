-- init.lua
vim.loader.enable()

vim.o.cmdheight = 0
vim.o.pumblend = 0
vim.o.winborder = 'rounded'
-- use the new extui module if available
pcall(function()
  require('vim._extui').enable({})
end)

-- set up snacks first since it provides global utilities
local munchies = require('munchies')
local snacks_spec = munchies.spec
vim.pack.add({ snacks_spec })
munchies.config()

local plugins = require('plugins')
local specs = plugins()

vim.pack.add(specs)

for _, plugin in pairs(plugins) do
  require('nvim.plug').config(plugin)
end

return M
