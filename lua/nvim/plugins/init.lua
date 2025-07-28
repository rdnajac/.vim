-- use nvim's native package manager to clone plugins and load them
local PACKDIR = vim.fn.stdpath('data') .. '/site/pack/core/opt/'

---@class PluginSpec
---@field src string
---@field name? string
---@field version? string

---@alias SpecList (string | PluginSpec)[]

---@type SpecList
local specs = {}

---@class PluginSpecMeta : PluginSpec
---@field build? string|fun(): nil
---@field config? fun(): nil
---@field dependencies? (string|PluginSpecMeta)[]
---@field event? vim.api.keyset.events|vim.api.keyset.events[]

---@param v string|PluginSpec|PluginSpecMeta
---@return string|PluginSpec|nil
local function to_spec(v)
  local function normalize_src(src)
    local is_user_repo = not src:match('^https?://') and not src:match('^~/') and src:match('^%S+/%S+$')
    return is_user_repo and ('https://github.com/' .. src) or src
  end

  if type(v) == 'string' then
    return normalize_src(v)
  end

  local spec = v.spec or v
  local src = normalize_src(spec[1] or spec.src)
  if not src then
    return nil
  end

  return {
    src = src,
    name = spec.name,
    version = spec.version,
  }
end

---@type table<string, PluginSpecMeta>
M = setmetatable({}, {
  __call = function()
    return specs
  end,

  __newindex = function(t, modname, mod)
    local key = mod.name or modname
    rawset(t, key, mod)

    local spec = to_spec(mod)
    if spec then
      specs[#specs + 1] = spec
    end

    if type(mod.dependencies) == 'table' then
      for _, dep in ipairs(mod.dependencies) do
        local dep_spec = to_spec(dep)
        if dep_spec then
          specs[#specs + 1] = dep_spec
        end
      end
    end
  end,
})

-- Determine current directory and Lua root
local this_file = debug.getinfo(1, 'S').source:sub(2) -- remove leading '@' or '='
local this_dir = assert(vim.fs.dirname(this_file), 'could not resolve current directory')
local lua_root = vim.fs.root(this_file, function(_, path)
  return path:match('/lua$') ~= nil
end) or this_dir

-- TODO: see how lazy.nvim does this
-- TODO: do we need the final check for leading dot?
-- Convert an absolute path to a Lua module name
---@param abs_path string
---@return string
local function to_modname(abs_path)
  return abs_path
    :sub(#lua_root + 2) -- +2 to remove the leading `./` or `/`
    :gsub('%.lua$', '') -- remove .lua extension
    :gsub('/', '.') -- replace slashes with dots
    :gsub('^%.*', '') -- remove leading dots
end

-- Require and register a plugin module by absolute path
---@param abs_path string
local function plug(abs_path)
  local modname = to_modname(abs_path)
  local ok, mod = pcall(require, modname)
  if not ok then
    Snacks.util.error('Failed to require "' .. modname .. '": ' .. mod)
    return
  end
  if type(mod) ~= 'table' then
    Snacks.util.error('Module "' .. modname .. '" did not return a table')
    return
  end
  M[modname] = mod -- triggers __newindex, adds to M and specs
end

-- Discover plugin files and directories in this_dir
local function import_plugins()
  for name, type_ in vim.fs.dir(this_dir, { depth = 1 }) do
    if type_ == 'file' and name:match('%.lua$') and name ~= 'init.lua' then
      plug(vim.fs.joinpath(this_dir, name))
    elseif type_ == 'directory' then
      local init = vim.fs.joinpath(this_dir, name, 'init.lua')
      if vim.uv.fs_stat(init) then
        plug(vim.fs.joinpath(this_dir, name))
      end
    end
  end
end

import_plugins()

return M
