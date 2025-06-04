local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim/'

if not vim.uv.fs_stat(lazypath) then
  load(vim.fn.system('curl -s https://raw.githubusercontent.com/folke/lazy.nvim/main/bootstrap.lua'))()
else
  vim.opt.rtp:prepend(lazypath)
end

---@class LazyConfig
require('lazy').setup({
  spec = { import = 'nvim.lazy.spec' },
  pkg = { enabled = false },
  rocks = { enabled = false },
  install = { colorscheme = { 'tokyonight' } },
  change_detection = { notify = false },
  ui = { border = 'rounded' },
  performance = {
    reset_packpath = true,
    rtp = {
      paths = {
        -- vim.fn.stdpath('data') .. '/lazy/snacks.nvim',
        vim.fn.stdpath('data') .. '/lazy/LazyVim',
      },
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
  profiling = { loader = true, require = false },
})

