local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim/'

if not vim.uv.fs_stat(lazypath) then
  load(vim.fn.system('curl -s https://raw.githubusercontent.com/folke/lazy.nvim/main/bootstrap.lua'))()
else
  vim.opt.rtp:prepend(lazypath)
end

-- HACK: skip loading `LazyVim` options
package.loaded['lazyvim.config.options'] = true

local M = {}

---@param opts LazyConfig
function M.load(opts)
  opts = vim.tbl_deep_extend('force', {
    spec = {
      {
        'LazyVim/LazyVim',
        {
          import = 'lazyvim.plugins',
          cond = vim.env.LAZY == '1', -- true only in strict LazyVim mode
          -- TODO: disable plugins
        },
      },
      { import = 'config.lazy.spec' },
    },
    rocks = { enabled = false },
    install = { colorscheme = { 'tokyonight' } },
    change_detection = { notify = false },
    ui = { border = 'rounded' },
    performance = {
      rtp = {
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
  }, opts or {})
  require('lazy').setup(opts)
end

return M
