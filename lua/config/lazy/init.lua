-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim/'

if not vim.uv.fs_stat(lazypath) then
  load(vim.fn.system('curl -s https://raw.githubusercontent.com/folke/lazy.nvim/main/bootstrap.lua'))()
else
  vim.opt.rtp:prepend(lazypath)
end

-- vim.g.lazyvim_check_order = false

package.loaded['lazyvim.config.options'] = true

local M = {}

---@param opts LazyConfig
function M.load(opts)
  opts = vim.tbl_deep_extend('force', {
    spec = { { import = 'config.lazy.spec' } },
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
