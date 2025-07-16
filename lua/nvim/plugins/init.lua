-- Use nvim's native package manager to clone plugins to
-- `~/.local/share/nvim/site/pack/core/opt/` and load them

--- A minimal plugin spec for vim.pack.add
---@class PluginSpec
---@field src string  plugin source URL (e.g. https://github.com/user/repo)
---@field name? string Optional short name for the plugin
---@field version? string Optional version (tag, branch, etc.)

--- A `lazy.nvim` compatible plugin specification
---@class PluginSpecMeta : PluginSpec
---@field config? fun() Optional config function
---@field dependencies? string[] List of plugin names this depends on
-- TODO: continue adding more fields as needed

-- XXX: this is subject to change in the future
_G.pack_dir = vim.fn.stdpath('data') .. '/site/pack/core/opt/'

---@type PluginSpec[]
local specs = {}

--- Create a minimal vim.pack spec from a plugin definition
---@param plugin table
---@return PluginSpec|nil
local function to_spec(plugin)
  local src = plugin.src or plugin[1]
  if not src then
    return nil
  end

  if not src:match('^https?://') and not src:match('^~/') then
    src = 'https://github.com/' .. src
  end

  return { src = src, name = plugin.name, version = plugin.version }
end

---@type table<string, PluginSpecMeta>
local M = {
  specs = specs, -- assign directly so it's not under __index
}

setmetatable(M, {
  __index = function(t, k)
    local mod = 'nvim.plugins.' .. k
    local ok, plugin = pcall(require, mod)
    if not ok then
      error('Module not found: ' .. mod)
    end

    local name = plugin.name or k

    -- avoid duplicate registration
    if rawget(t, name) then
      return rawget(t, name)
    end

    table.insert(specs, to_spec(plugin))
    for _, dep in ipairs(plugin.dependencies or {}) do
      table.insert(specs, to_spec({ dep }))
    end
    rawset(t, name, plugin)
    return plugin
  end,
})

-- plugins are available immediately after `vim.pack.add()`
vim.pack.add({ 'https://github.com/nvim-lua/plenary.nvim' })

local Path = require('plenary.path')
local scandir = require('plenary.scandir')

---@diagnostic disable-next-line: assign-type-mismatch
local this_dir = Path.new(debug.getinfo(1, 'S').source:sub(2)):parent():absolute()

-- Scan plugin dir for top-level *.lua and subdirs with init.lua
for _, entry in ipairs(scandir.scan_dir(this_dir, { depth = 2, add_dirs = true })) do
  local path = Path.new(entry):make_relative(this_dir)
  local parts = vim.split(path, Path.path.sep)

  local name = nil
  if #parts == 1 and path:match('%.lua$') and path ~= 'init.lua' then
    name = path:match('^(.-)%.lua$')
  elseif #parts == 2 and parts[2] == 'init.lua' then
    name = parts[1]
  end

  if name then
    _ = M[name] -- triggers plugin load, appends to M.specs
  end
end

-- Register plugin specs with Neovim
vim.pack.add(M.specs)

local aug = vim.api.nvim_create_augroup('LazyLoad', { clear = true })

for _, plugin in pairs(M) do
  if plugin.event then
    vim.api.nvim_create_autocmd(plugin.event, {
      group = aug,
      once = true,
      callback = plugin.config,
    })
  elseif plugin.config then
    plugin.config()
  end
end

return M
