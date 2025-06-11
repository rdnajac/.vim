-- XXX: experimental!
vim.loader.enable()

local lazypath = vim.fn.stdpath('data') .. '/lazy'
local lazynvim = lazypath .. '/lazy.nvim'

-- set up `Snacks` globals for debugging " {{{2
vim.opt.rtp:append(lazypath .. '/snacks.nvim')

Snacks = require('snacks')
_G.bt = function()
  Snacks.debug.backtrace()
end
_G.p = function(...)
  Snacks.debug.profile(...)
end
_G.dd = function(...)
  Snacks.debug.inspect(...)
end
_G.ddd = function(...)
  if vim.env.DEBUG then
    Snacks.debug.inspect(...)
  end
end

vim.print = _G.dd

-- optional profiling with `PROF=1 nvim` {{{2
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

-- bootstrap lazy.nvim and LazyVim " {{{2
if not vim.uv.fs_stat(lazynvim) then
  load(vim.fn.system('curl -s https://raw.githubusercontent.com/folke/lazy.nvim/main/bootstrap.lua'))()
else
  vim.opt.rtp:prepend(lazynvim)
end

---@class opts LazyConfig
require('config.lazy').load({
  profiling = {
    loader = false,
    require = false,
  },
  dev = {
    path = '~/GitHub/folke',
    -- patterns = { 'folke' },
    fallback = true,
  },
})

--- load settings **after** `VeryLazy` event " {{{1
vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    require('nvim.diagnostic')
    require('nvim.lsp')
    require('nvim.settings')
  end,
})
-- vim: fdm=marker fdl=1
