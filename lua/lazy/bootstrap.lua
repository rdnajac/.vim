local lazynvim = lazypath .. '/lazy.nvim'

if not vim.uv.fs_stat(lazynvim) then
  load(vim.fn.system('curl -s https://raw.githubusercontent.com/folke/lazy.nvim/main/bootstrap.lua'))()
else
  vim.opt.rtp:prepend(lazynvim)
end

---@type LazyConfig
require('lazy').setup({
  spec = {
    { import = 'lazy.spec' },
    { import = 'lazy.lang' },
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
    -- icons = require('lazy.emojis').ui,
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
