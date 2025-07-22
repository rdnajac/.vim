-- Use nvim's native package manager to clone plugins to
-- `~/.local/share/nvim/site/pack/core/opt/` and load them

-- XXX: this is subject to change in the future
_G.pack_dir = vim.fn.stdpath('data') .. '/site/pack/core/opt/'

-- plugins are available immediately after `vim.pack.add()`
vim.pack.add({ 'https://github.com/nvim-lua/plenary.nvim' })

local Path = require('plenary.path')
local scandir = require('plenary.scandir')

-- Dynamically determine the root directory of this plugin
local this = Path:new(debug.getinfo(1, 'S').source:sub(2))
local this_dir = this:parent()
local lua_root = this_dir
while lua_root:parent() ~= lua_root do
  if lua_root:parent().filename:match('/lua$') then
    lua_root = lua_root:parent()
    break
  end
  lua_root = lua_root:parent()
end

--- minimal plugin spec for vim.pack.add
---@class PluginSpec
---@field src string  plugin source URL (e.g. https://github.com/user/repo)
---@field name? string Optional short name for the plugin
---@field version? string Optional version (tag, branch, etc.)

---@type (string|PluginSpec)[]
local specs = {}

--- Convert a plugin table to a minimal spec for `vim.pack.add`
---@param plugin PluginSpec|string
---@return PluginSpecMeta|nil
local function to_spec(plugin)
  if type(plugin) ~= 'table' then
    log.warn('Plugin is not a table but a ' .. type(plugin) .. ': ', tostring(plugin))
    return nil
  end
  local src = plugin.src or plugin[1]
  if not src then
    return nil
  end
  if not src:match('^https?://') and not src:match('^~/') then
    src = 'https://github.com/' .. src
  end
  return { src = src, name = plugin.name, version = plugin.version }
end

--- `lazy.nvim` compatible plugin specification
---@class PluginSpecMeta
---@field src? string
---@field name? string
---@field version? string
---@field build? string|function Optional build command or function
---@field config? fun() Optional config function
---@field dependencies? string[] List of plugin names this depends on
---@field event? string Event to trigger loading (see `:h events`)

---@type table<string, PluginSpecMeta>
local M = setmetatable({}, {
  __newindex = function(t, k, v)
    rawset(t, k, v)

    local spec = to_spec(v)
    if spec then
      table.insert(specs, spec)
    end
    if type(v) == 'table' and v.dependencies then
      for _, dep in ipairs(v.dependencies) do
        table.insert(specs, { src = dep })
      end
    end
  end,
})

local load = function(file_path)
  local modname = Path:new(file_path):make_relative(lua_root.filename):gsub(Path.path.sep, '.')
  local ok, plugin = pcall(require, modname)
  if not ok or type(plugin) ~= 'table' then
    vim.notify('Error loading plugin: ' .. vim.inspect(plugin), vim.log.levels.ERROR)
    return
  end
  M[modname] = plugin -- triggers __newindex, adds to specs
end

-- import top-level plugins (non-recursive)
-- scans the folder for `*.lua` files, excluding `init.lua`
-- then loads them as modules after stripping the `.lua` extension
scandir.scan_dir(this_dir:absolute(), {
  depth = 1,
  search_pattern = function(entry)
    return entry:match('%.lua$') and not entry:match('/init%.lua$')
  end,
  on_insert = function(filename)
    load(filename:gsub('%.lua$', ''))
  end,
})

-- finds subdirectories that contain `init.lua`
scandir.scan_dir(this_dir:absolute(), {
  depth = 2,
  only_dirs = true,
  on_insert = function(dirname)
    if Path:new(dirname):joinpath('init.lua'):exists() then
      load(dirname)
    end
  end,
})

function build()
  for _, spec in pairs(M) do
    if spec.build then
      if type(spec.build) == 'string' then
        vim.fn.system(spec.build)
      elseif type(spec.build) == 'function' then
        spec.build()
      end
    end
  end
end

function config()
  local aug = vim.api.nvim_create_augroup('LazyLoad', { clear = true })
  for _, plugin in pairs(M) do
    if type(plugin) == 'table' and type(plugin.config) == 'function' then
      if plugin.event then
        vim.api.nvim_create_autocmd(plugin.event, {
          group = aug,
          once = true,
          callback = plugin.config,
        })
      else
        plugin.config()
      end
    end
  end
end

vim.pack.add(specs)
config()

-- TODO: build only on first load
-- M:Build()

-- Available events to hook into ~
-- • *PackChangedPre* - before trying to change plugin's state.
-- • *PackChanged* - after plugin's state has changed.
--
-- Each event populates the following |event-data| fields:
-- • `kind` - one of "install" (install on disk), "update" (update existing
--   plugin), "delete" (delete from disk).
-- • `spec` - plugin's specification.
-- • `path` - full path to plugin's directory.

-- load local plugin (only works if for git repositories)
-- vim.pack.add({ vim.fn.stdpath('config') .. '/dev/vimline' })

return M
