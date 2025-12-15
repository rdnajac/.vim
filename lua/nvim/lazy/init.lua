-- require('nvim.lazy.file')
local M = {}

M.spec = {
  -- { 'folke/lazy.nvim' },
  -- { 'LazyVim/LazyVim' },
  {
    'folke/lazydev.nvim',
    opts = {
      library = {
        -- PERF: no longer necessary witH `$VIMRUNTIME/lua/uv/_meta.lua`
        -- { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        { path = 'LazyVim', words = { 'LazyVim' } },
        { path = 'snacks.nvim', words = { 'Snacks' } },
        { path = 'lazy.nvim', words = { 'LazyVim' } },
        { path = 'mini.nvim', words = { 'Mini.*' } },
        { path = 'nvim', words = { 'nv' } },
      },
    },
  },
}

M.init = function()
  vim.pack.add({ 'https://github.com/LazyVim/LazyVim.git' }, { load = false })
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
end

return M
