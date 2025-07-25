-- use nvim's native package manager to clone plugins and load them
_G.PACKDIR = vim.fn.expand('~/.local/share/nvim/site/pack/core/opt/')

---@class PluginSpec
---@field src string
---@field name? string
---@field version? string

---@class PluginSpecMeta
---@field build? string|function
---@field config? fun()
---@field dependencies? string[]
---@field event? string|string[]

---@alias SpecList (string|PluginSpec)[]

---@type SpecList
local specs = {}

---@type table<string, PluginSpecMeta>
local M = {}

---@param src string
---@return boolean
local function is_user_repo(src)
  return (not src:match('^https?://')) and (not src:match('^~/')) and src:match('^%S+/%S+$') ~= nil
end

---@param src string
---@return string
local function plug(src)
  return is_user_repo(src) and ('https://github.com/' .. src) or src
end

---@param v string|PluginSpec|PluginSpecMeta
---@return string|PluginSpec|nil
local function to_spec(v)
  local x = (type(v) == 'table') and (v.spec or v) or v
  if type(x) == 'string' then
    return plug(x)
  elseif type(x) == 'table' then
    local src = x.src or x[1]
    if type(src) ~= 'string' or src == '' then
      return nil
    end
    return { src = plug(src), name = x.name, version = x.version }
  end
  return nil
end

---@param name string
---@param mod PluginSpecMeta
local function add_plugin(name, mod)
  M[name] = mod
  local main = to_spec(mod)
  if main then
    specs[#specs + 1] = main
  end
  if type(mod.dependencies) == 'table' then
    for _, dep in ipairs(mod.dependencies) do
      if type(dep) == 'string' then
        specs[#specs + 1] = plug(dep)
      end
    end
  end
end

local src = debug.getinfo(1, 'S').source
src = type(src) == 'string' and src or ''
if src:sub(1, 1) == '@' then
  src = src:sub(2)
end

local this = src
local this_dir = assert(vim.fs.dirname(this), 'cannot resolve this_dir')
local lua_root = vim.fs.root(this, function(_, path)
  return path:match('/lua$') ~= nil
end) or this_dir

---@param abs string
---@return string
local function to_modname(abs)
  local rel = abs:sub(#lua_root + 2)
  rel = rel:gsub('%.lua$', ''):gsub('/', '.'):gsub('^%.*', '')
  return rel
end

---@param file_path string
local function load(file_path)
  local modname = to_modname(file_path)
  local ok, plugin = pcall(require, modname)
  if not ok or type(plugin) ~= 'table' then
    vim.notify('Error loading plugin ' .. modname .. ': ' .. vim.inspect(plugin), vim.log.levels.ERROR)
    return
  end
  add_plugin(modname, plugin)
end

local function import_plugins()
  for name, type_ in vim.fs.dir(this_dir, { depth = 1 }) do
    if type_ == 'file' and name:match('%.lua$') and name ~= 'init.lua' then
      load(vim.fs.joinpath(this_dir, name))
    end
  end

  for rel, type_ in vim.fs.dir(this_dir, { depth = 2 }) do
    if type_ == 'directory' then
      local init = vim.fs.joinpath(this_dir, rel, 'init.lua')
      if vim.uv.fs_stat(init) then
        load(vim.fs.joinpath(this_dir, rel))
      end
    end
  end
end

local function lazy_load()
  local lazy = require('nvim.util.lazy')
  for name, plugin in pairs(M) do
    if plugin.config then
      lazy.config(plugin)
    end
    -- TODO
    -- if plugin.build then
    --   lazy.build(name, plugin, M)
    -- end
  end
end

import_plugins()
vim.pack.add(specs)
lazy_load()

return M
