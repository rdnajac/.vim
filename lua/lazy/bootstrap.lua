---@type LazyConfig
require('lazy').setup({
  spec = {
    { import = 'lazy.spec' },
    { import = 'lazy.lang' },
    { import = 'lazy.ui' },
    -- { import = 'lazy.xtra.formatting' },
    { import = 'lazy.xtra.util' },
  },
  profiling = { loader = false, require = false },
  rocks = { enabled = false },
  dev = {
    path = '~/GitHub/rdnajac',
    fallback = true,
  },
  install = { colorscheme = { 'tokyonight' } },
  ui = {
    border = 'rounded',
    -- stylua: ignore
    custom_keys = { ['<localleader>d'] = function(plugin) dd(plugin) end },
  },
  change_detection = { notify = false },
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
