-- init.lua
vim.loader.enable()

vim.o.cmdheight = 0
vim.o.pumblend = 0
vim.o.winborder = 'rounded'
-- use the new extui module if available
pcall(function()
  require('vim._extui').enable({})
end)

-- 1. requires snacks setup
require('munchies')
require('nvim.colorscheme')

-- make icons globally available
local snacks = require('snacks.picker.config.defaults').defaults.icons
local mine = require('nvim.icons')

_G.icons = vim.tbl_deep_extend('force', {}, snacks, mine)

_G.dd = function(...)
  return (function(...)
    return Snacks.debug.inspect(...)
  end)(...)
end

vim.print = _G.dd

-- stylua: ignore
_G.bt = function() Snacks.debug.backtrace() end

_G.plugins = require('nvim.plugins')

local pluginspecs = plugins()

-- deduplicate plugins
-- XXX: uncomment on 7/29/25
-- if vim.list.unique then
--   vim.list.unique(pluginspecs)
-- end
vim.pack.add(pluginspecs)

local aug = vim.api.nvim_create_augroup('LazyLoad', { clear = true })

---@param ev string|string[]
---@param cb fun(): nil
local function lazy_load_config(ev, cb)
  vim.api.nvim_create_autocmd(ev, {
    group = aug,
    once = true,
    callback = cb,
  })
end

local function configure_plugin(plugin)
  if type(plugin.config) == 'function' then
    if plugin.event then
      -- dd('Lazy loading config for', plugin[1], 'on event', plugin.event)
      lazy_load_config(plugin.event, plugin.config)
    else
      plugin.config()
    end
  end
end

local function do_configs()
  for _, plugin in pairs(plugins) do
    configure_plugin(plugin)
  end
end

do_configs()
-- TODO: build?
