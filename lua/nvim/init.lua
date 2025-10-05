_G.nv = require('nvim.util')

-- Load the Plugin class and helpers from nvim.plugins
local module = require('nvim.plugins')
local Plugin = module.Plugin

-- Initialize and process plugins from the lua/nvim/plugins directory
local plugins_dir = nv.stdpath.config .. '/lua/nvim/plugins'
local plugin_files = vim.fn.globpath(plugins_dir, '*.lua', false, true)

-- Step 1: Create all Plugin objects
local plugins = vim
  .iter(plugin_files)
  :map(function(path)
    return path:match('^.+/(.+)%.lua$')
  end)
  :filter(function(name)
    return name ~= 'init'
  end)
  :map(function(name)
    local t = require('nvim.plugins.' .. name)
    return vim.islist(t) and t or { t }
  end)
  :flatten()
  :map(function(spec)
    return Plugin.new(spec)
  end)
  :totable()

-- Step 2: Collect all specs from enabled plugins
local all_specs = vim
  .iter(plugins)
  :map(function(plugin)
    return plugin:get_specs()
  end)
  :flatten()
  :totable()

-- Step 3: Add all plugins at once
if #all_specs > 0 then
  vim.pack.add(all_specs)
end

-- Step 4: Run the rest of the initialization for each plugin
for _, plugin in ipairs(plugins) do
  plugin:init()
end

nv.plugins = plugins

-- Add the unloaded function to nv.plugins
nv.plugins.unloaded = module.unloaded

local root = 'nvim'
local dir = nv.stdpath.config .. '/lua/' .. root
local mods = {}

-- top-level .lua files
for _, f in ipairs(vim.fn.globpath(dir, '*.lua', false, true)) do
  local name = f:match('([^/]+)%.lua$')
  if name and name ~= 'init' then
    mods[name] = true
  end
end

-- one level of subdirs
for _, d in ipairs(vim.fn.globpath(dir, '*/', false, true)) do
  local subname = d:match('([^/]+)/$')
  if subname then
    local submods = {}
    for _, f in ipairs(vim.fn.globpath(d, '*.lua', false, true)) do
      local child = f:match('([^/]+)%.lua$')
      if child and child ~= 'init' then
        submods[child] = true
      end
    end
    if next(submods) then
      mods[subname] = submods
    else
      mods[subname] = true
    end
  end
end

-- dd(mods)
-- _G.nv = vim._defer_require('nvim', mods)
