-- init.lua
vim.loader.enable()

vim.o.cmdheight = 0
vim.o.pumblend = 0
vim.o.winborder = 'rounded'

-- use the new extui module if available
pcall(function()
  require('vim._extui').enable({})
end)

local start_configs = {}
_G.plugins = require('plugins')
local plug = require('nvim.plug')

for name, plugin in pairs(_G.plugins.plugins) do
  if plugin.build then
    plug.build(name, plugin.build)
  end
  if type(plugin.config) == 'function' then
    if plugin.event then
      -- Lazyload based on event
      plug.lazyload(plugin.event, plugin.config)
    else
      -- Eager-load plugins (with optional priority)
      local entry = { name, plugin.config }
      if plugin.priority and plugin.priority ~= 0 then
        table.insert(start_configs, 1, entry)
        -- TODO: handle priority properly
      else
        table.insert(start_configs, entry)
      end
    end
  end
end

vim.pack.add(_G.plugins.specs)

for _, config in ipairs(start_configs) do
  local ok, err = pcall(config[2])
  if not ok then
    vim.notify(('Failed to configure plugin "%s": %s'):format(config[1], err), vim.log.levels.ERROR)
  end
end

require('nvim.diagnostic')
