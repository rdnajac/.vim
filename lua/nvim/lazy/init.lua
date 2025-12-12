local plugdir = vim.g.plughome
local lazypath = vim.fs.joinpath(plugdir, 'lazy.nvim')
vim.opt.rtp:prepend(lazypath)

require('lazy').setup(require('nvim.lazy.spec'), {
  dev = {
    -- path = ...,
    -- fallback = true,
  },
  performance = {
    reset_packpath = false,
    rtp = { reset = false },
  },
  profiling = {
    loader = false,
    require = false,
  },
  pkg = { enabled = false },
  rocks = { enabled = false },
  -- install = { colorscheme = { 'tokyonight' } },
  change_detection = { enabled = false, notify = false },
})
-- require('nvim.lazy.file')
local M = {}

M.spec = {
  -- { 'folke/lazy.nvim' },
  -- { 'LazyVim/LazyVim' },
}

return M
