-- Use nvim's native package manager to clone plugins to
-- `~/.local/share/nvim/site/pack/core/opt/` and load them

--- minimal plugin spec for vim.pack.add
---@class PluginSpec
---@field src string  plugin source URL (e.g. https://github.com/user/repo)
---@field name? string Optional short name for the plugin
---@field version? string Optional version (tag, branch, etc.)

--- `lazy.nvim` compatible plugin specification
---@class PluginSpecMeta : PluginSpec
---@field build? string|function Optional build command or function
---@field config? fun() Optional config function
---@field dependencies? string[] List of plugin names this depends on
---@field event? string Event to trigger loading (see `:h events`)

-- XXX: this is subject to change in the future
_G.pack_dir = vim.fn.stdpath('data') .. '/site/pack/core/opt/'

-- add local plugins
-- vim.pack.add({ vim.fn.stdpath('config') .. '/dev/vim-lol' })

-- plugins are available immediately after `vim.pack.add()`
vim.pack.add({ 'https://github.com/nvim-lua/plenary.nvim' })

local Path = require('plenary.path')
local scandir = require('plenary.scandir')
local log = require('plenary.log').new({
  plugin = 'plugin_init',
  -- level = 'debug',
  use_console = true,
  info_level = 2,
  truncate = false,
})

local M = {}

--- list of specs built from plugin definitions
---@type PluginSpec[]
M.specs = {}

--- Parse plugin object to a minimal spec
---@param plugin PluginSpecMeta
---@return PluginSpec?
local function to_spec(plugin)
  local src = plugin.src or plugin[1]

  if not src then
    log.warn('Missing plugin source in: ', vim.inspect(plugin))
    return nil
  end
  if not src:match('^https?://') and not src:match('^~/') then
    src = 'https://github.com/' .. src
  end
  return { src = src, name = plugin.name, version = plugin.version }
end

-- automatically convert tables in M[name] to plugin specs
setmetatable(M, {
  __newindex = function(t, k, v)
    rawset(t, k, v)
    if type(v) == 'table' and (v.src or v[1]) then
      local spec = to_spec(v)
      if spec then
        log.debug('Added plugin: ', vim.inspect(spec))
        table.insert(t.specs, spec)
        if v.dependencies then
          for _, dep in ipairs(v.dependencies) do
            local ds = to_spec({ dep })
            if ds then
              log.debug('Added dependency: ', vim.inspect(ds))
              table.insert(t.specs, ds)
            end
          end
        end
      end
    end
  end,
})

function M:init()
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

  local function load(file_path)
    local rel = Path:new(file_path):make_relative(lua_root.filename)
    local modname = rel:gsub('%.lua$', ''):gsub(Path.path.sep, '.')
    local ok, plugin = pcall(require, modname)
    if ok and type(plugin) == 'table' then
      local plugin_name = modname
      log.debug('Loading plugin: ', plugin_name)
      M[plugin_name] = plugin
    else
      vim.notify('Error loading plugin: ' .. vim.inspect(plugin), vim.log.levels.ERROR)
    end
  end

  -- load any lua files in this directory (non-recursive)
  scandir.scan_dir(this_dir:absolute(), {
    depth = 1,
    search_pattern = function(entry)
      return entry:match('%.lua$') and not entry:match('init%.lua$')
    end,
    on_insert = load,
  })

  -- look for nested modules with their own init.lua
  scandir.scan_dir(this_dir:absolute(), {
    depth = 2,
    only_dirs = true,
    on_insert = function(dir)
      if Path:new(dir):joinpath('init.lua'):exists() then
        load(dir)
      end
    end,
  })

  vim.pack.add(M.specs)
end

function M:Build()
  for _, spec in ipairs(M) do
    if spec.build then
      if type(spec.build) == 'string' then
        vim.fn.system(spec.build)
      elseif type(spec.build) == 'function' then
        spec.build()
      end
    end
  end
end

function M:config()
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

M:init()
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

M:config()

return M
