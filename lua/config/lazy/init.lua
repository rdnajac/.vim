vim.loader.enable() -- XXX: experimental!
-- TODO: fix tabline/winbar

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
    -- Snacks.debug.inspect(...)
    print(...)
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

-- bootstrap `lazy.nvim` and `LazyVim` {{{2
if not vim.uv.fs_stat(lazynvim) then
  load(vim.fn.system('curl -s https://raw.githubusercontent.com/folke/lazy.nvim/main/bootstrap.lua'))()
else
  vim.opt.rtp:prepend(lazynvim)
end

require('lazy').setup({ ---@type LazyConfig
  spec = { { import = 'config.lazy.spec' }, },
  profiling = {
    loader = false,
    require = false,
  },
  rocks = { enabled = false },
  dev = {
    path = '~/GitHub/rdnajac',
    fallback = true,
  },
  install = { colorscheme = { 'tokyonight' } },
  ui = {
    border = 'rounded',
    icons = require('config.lazy.emojis').ui.icons,
    -- stylua: ignore
    custom_keys = {
      ['<localleader>d'] = function(plugin) dd(plugin) end,
    },
  },
  change_detection = { notify = false },
  performance = {
    rtp = {
      -- paths = { vim.fn.stdpath('config') .. '/pack/tpope/start' },
      disabled_plugins = {
        'gzip',
        -- 'matchit',
        -- 'matchparen',
        -- 'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})
_G.LazyVim = require('lazyvim.util')
-- vim: fdm=marker fdl=1
