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

-- HACK: autocmds can be loaded lazily when not opening a file
local lazy_env = vim.env.LAZY
local lazy_autocmds = vim.fn.argc(-1) == 0

if lazy_env == nil then
  if not lazy_autocmds then
    require('config.autocmds')
  end
end

--- load settings **after** `VeryLazy` event " {{{1
vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    if lazy_env == nil then
      require('config.options')
      require('config.keymaps')
      if lazy_autocmds then
        require('config.autocmds')
      end
    elseif lazy_env == '0' then
      print('using hax')
    else
      print('zzz')
    end
    require('nvim.diagnostic')
    require('nvim.lsp')
    -- require('munchies')
    vim.opt.clipboard = vim.env.SSH_TTY and '' or 'unnamedplus'
    vim.opt.foldexpr = 'v:lua.LazyVim.ui.foldexpr()'
  end,
})
-- vim: fdm=marker fdl=1
