vim.loader.enable() -- XXX: experimental!
-- TODO: fix tabline/winbar

_G.lazypath = vim.fn.stdpath('data') .. '/lazy'

-- HACK: add `Snacks` snacks to rtp early
vim.opt.rtp:append(lazypath .. '/snacks.nvim')

local Snacks = require('snacks')
-- stylua: ignore start
_G.bt  = function()    Snacks.debug.backtrace() end
_G.p   = function(...) Snacks.debug.profile(...) end
_G.dd  = function(...) Snacks.debug.inspect(...) end
_G.ddd = function(...) if vim.env.DEBUG then print(...) end end
-- stylua: ignore end
vim.print = _G.dd

-- optional profiling with `PROF=1 nvim`
if vim.env.PROF then
  ---@type snacks.profiler.Config
  local profiler = {
    startup = {
      -- event = 'VeryLazy',
      -- event = 'UIEnter',
    },
    presets = { startup = { min_time = 0, sort = false } },
  }
  Snacks.profiler.startup(profiler)
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
  vim.cmd([[do VimResized]])
  LazyVim.format.setup()
  LazyVim.root.setup()
end)
