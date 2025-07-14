-- Use nvim's native package manager to clone plugins to
-- `~/.local/share/nvim/site/pack/core/opt/` and load them
local M = {}

setmetatable(M, {
  __index = function(t, k)
    local mod = 'nvim.plugins.' .. k
    local ok, plugin = pcall(require, mod)
    if ok then
      t[k] = plugin
      return plugin
    else
      error('Module not found: ' .. mod)
    end
  end,
})

M.specs = {}
M.plugins = {}

local function plug(name, plugin)
  local spec = { src = 'https://github.com/' .. plugin[1] }
  if plugin.version then
    spec.version = plugin.version
  end
  if plugin.name then
    spec.name = plugin.name
  end
  M[name] = plugin
  table.insert(M, { plugin = plugin, spec = spec, name = name })
  table.insert(M.specs, spec)
  M.plugins[name] = plugin
end

local this_dir = debug.getinfo(1, 'S').source:sub(2):match('(.+)/[^/]*$')

local function discover_plugins(pattern, extract_name)
  local files = vim.fn.glob(this_dir .. pattern, true, true)
  for _, file in ipairs(files) do
    local name = extract_name(file)
    if name and name ~= 'init' then
      local modulename = 'nvim.plugins.' .. name
      local plugin = require(modulename)
      if type(plugin) == 'table' and plugin[1] then
        plug(name, plugin)
      end
    end
  end
end

M.init = function()
  -- Load plugins in the current directory
  discover_plugins('/*.lua', function(file)
    return file:match('([^/]+)%.lua$')
  end)

  -- Load plugins from subdirectories containing `init.lua`
  discover_plugins('/*/init.lua', function(file)
    return file:match('/([^/]+)/init%.lua$')
  end)

  -- see `:h vim.pack`
  vim.pack.add(M.specs)

  -- Function to load plugins after a specific event
  local aug = vim.api.nvim_create_augroup('LazyLoad', { clear = true })
  _G.lazyload = function(event, cb)
    vim.api.nvim_create_autocmd(event, {
      group = aug,
      once = true,
      callback = cb,
    })
  end

  for _, entry in ipairs(M) do
    local plugin = entry.plugin or entry
    if type(plugin.config) == 'function' then
      if plugin.event then
        lazyload(plugin.event, plugin.config)
      else
        plugin.config()
      end
    end
  end
end

M.init()

return M
