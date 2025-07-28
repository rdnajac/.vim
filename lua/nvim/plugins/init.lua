-- use nvim's native package manager to clone plugins and load them
---Manages plugins only in a dedicated [vim.pack-directory]() (see |packages|):
---`$XDG_DATA_HOME/nvim/site/pack/core/opt`.
-- vim.g.PACKDIR = vim.fn.stdpath('data') .. '/site/pack/core/opt/'
-- /Users/rdn/.local/neovim/share/nvim/runtime/lua/vim/pack.lua:198
-- `return vim.fs.joinpath(vim.fn.stdpath('data'), 'site', 'pack', 'core', 'opt')`
vim.g.PACKDIR = vim.fn.expand('~/.local/share/nvim/site/pack/core/opt/')

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
---@field enabled? boolean|fun():boolean

---@param v string|PluginSpec|PluginSpecMeta
---@return string|PluginSpec|nil
local function to_spec(v)
  local function is_user_repo(src)
    return src:match('^%S+/%S+$') and not src:match('^https?://') and not src:match('^~/')
  end

  local src = type(v) == 'string' and v or v[1] or v.src
  if not src or src == '' or type(src) ~= 'string' then
    return nil
  end

  if is_user_repo(src) then
    src = 'https://github.com/' .. src
  end

  if type(v) == 'string' or (not v.name and not v.version) then
    return src
  end

  return { src = src, name = v.name, version = v.version }
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

-- Require and register a plugin module by absolute path
---@param path string
local function plug(path)
  local modname = path
    :sub(#lua_root + 2) -- +2 to remove the leading `./` or `/`
    :gsub('%.lua$', '') -- remove .lua extension
  -- :gsub('/', '.') -- replace slashes with dots
  -- :gsub('^%.*', '') -- remove leading dots
  local ok, mod = pcall(require, modname)
  if not ok then
    Snacks.notify.error('Failed to require "' .. modname .. '": ' .. mod)
    return
  end
  if mod.enabled == false or (type(mod.enabled) == 'function' and not mod.enabled()) then
    -- Snacks.notify.info('Skipping plugin "' .. modname .. '" due to enabled=false', { hl_group = 'Statement' })
    return
  end
  -- ~/.local/neovim/share/nvim/runtime/lua/vim/pack.lua:238
  local name = (mod.name or mod.src or mod[1])
  if name then
    name = name:gsub('%.git$', ''):match('[^/]+$')
  end
  M[name or modname] = mod
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

require('nvim.util.build')

import_plugins()

return M
