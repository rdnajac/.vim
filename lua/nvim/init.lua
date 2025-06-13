vim.loader.enable() -- XXX: experimental!
-- TODO: fix tabline/winbar

_G.lazypath = vim.fn.stdpath('data') .. '/lazy'

_G.dd = function(...)
  return (function(...)
    return Snacks.debug.inspect(...)
  end)(...)
end
_G.bt = function()
  Snacks.debug.backtrace()
end
vim.print = _G.dd

-- optional profiling with `PROF=1 nvim`
if vim.env.PROF then
  vim.opt.rtp:append(lazypath .. '/snacks.nvim')
  ---@type snacks.profiler.Config
  local profiler = {
    startup = {
      -- event = 'VeryLazy',
      -- event = 'UIEnter',
    },
    presets = { startup = { min_time = 0, sort = false } },
  }
  require('snacks').profiler.startup(profiler)
end

require('lazy.bootstrap')

-- autocmds can be loaded lazily when not opening a file
local lazy_autocmds = vim.fn.argc(-1) == 0

if not lazy_autocmds then
  require('nvim.autocmds')
end

LazyVim.on_very_lazy(function()
  if lazy_autocmds then
    require('nvim.autocmds')
  end
  require('nvim.keymaps')
  require('nvim.options')
  require('munchies')
  require('util')
end)
