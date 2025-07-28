-- init.lua
vim.loader.enable()

vim.o.cmdheight = 0
vim.o.pumblend = 0
vim.o.winborder = 'rounded'

-- use the new extui module if available
pcall(function()
  require('vim._extui').enable({})
end)

require('munchies')
-- 1. requires snacks setup
-- 2. registers vim commands

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

vim.pack.add(plugins())

local aug = vim.api.nvim_create_augroup('LazyLoad', { clear = true })

---@param ev string|string[]
---@param callback fun(): nil
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
