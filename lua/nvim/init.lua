_G.nv = require('nvim.util')

nv.plugins = require('nvim.plugins')

local plugin_system = nv.plugins
local plugin_specs = {}
local plugins_dir = nv.stdpath.config .. '/lua/nvim/plugins'
local loaded_plugin_modules = nv.module.load_modules(plugins_dir, 'nvim.plugins')

for _, plugin_module in pairs(loaded_plugin_modules) do
  local specs_list = vim.islist(plugin_module) and plugin_module or { plugin_module }
  for _, plugin_spec in ipairs(specs_list) do
    table.insert(plugin_specs, plugin_system.Plug(plugin_spec))
  end
end

vim.pack.add(plugin_system._specs)

for _, plugin_instance in ipairs(plugin_specs) do
  plugin_instance:init()
end

vim.schedule(function()
  require('which-key').add(plugin_system._keys)
  for plugin_name, after_fn in pairs(plugin_system._after) do
    nv.did.after[plugin_name] = pcall(after_fn)
  end
  nv.lazyload(function()
    for plugin_name, command_fn in pairs(plugin_system._commands) do
      nv.did.commands[plugin_name] = pcall(command_fn)
    end
  end, 'CmdLineEnter')
end)

return nv
