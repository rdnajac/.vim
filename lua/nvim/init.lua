_G.nv = require('nvim.util')

-- Load the Plugin class and helpers from nvim.plugins
local module = require('nvim.plugins')
local Plugin = module.Plugin

-- Initialize and process plugins from the lua/nvim/plugins directory
local dir = nv.stdpath.config .. '/lua/nvim/plugins'
local files = vim.fn.globpath(dir, '*.lua', false, true)

nv.plugins = vim
  .iter(files)
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
    local P = Plugin.new(spec)
    P:init()
    return P
  end)
  :totable()

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
