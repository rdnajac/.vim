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

-- TODO: support .enabled boolean
local function load(file_path)
  local rel = Path:new(file_path):make_relative(lua_root.filename)
  local modname = rel:gsub('%.lua$', ''):gsub(Path.path.sep, '.')
  local ok, plugin = pcall(require, modname)
  if ok and type(plugin) == 'table' then
    local plugin_name = modname
    log.debug('Loading plugin: ', plugin_name)
    -- FIXME:
    -- M[plugin_name] = plugin
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
