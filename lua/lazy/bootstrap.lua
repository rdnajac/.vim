---@type LazyConfig
local lazypath = vim.fn.stdpath('data') .. '/lazy'
local lazynvim = lazypath .. '/lazy.nvim'
vim.opt.rtp:prepend(lazynvim)

require('lazy').setup({
  spec = {
    { import = 'plugins' },
    { import = 'lang' },
    -- { import = 'lazy.lang' },
    -- { import = 'lazy.ui' },
    -- { import = 'lazy.xtra' },
  },
  profiling = { loader = false, require = false },
  rocks = { enabled = false },
  install = { colorscheme = { 'tokyonight' } },
  ui = {
    border = 'rounded',
    -- stylua: ignore
    custom_keys = { ['<localleader>d'] = function(plugin) dd(plugin) end },
  },
  change_detection = {
    enabled = false,
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'matchit',
        -- 'matchparen',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})
