local plugdir = vim.g.plughome
local lazypath = vim.fs.joinpath(plugdir, 'lazy.nvim')
vim.opt.rtp:prepend(lazypath)

local spec = require('nvim.folke.lazy.spec')

require('lazy').setup(spec, {
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
