local lazy_file_events = { 'BufReadPost', 'BufNewFile', 'BufWritePre' }
local triggered = false

vim.api.nvim_create_autocmd(lazy_file_events, {
  group = vim.api.nvim_create_augroup('LazyFile', { clear = true }),
  callback = function()
    if not triggered then
      triggered = true
      vim.api.nvim_exec_autocmds('User', { pattern = 'LazyFile' })
    end
  end,
  desc = 'User LazyFile event from LazyVim',
})

local M = {}

M.init = function()
  local lazypath = vim.fs.joinpath(vim.g.plug_home, 'lazy.nvim')
  vim.opt.rtp:prepend(lazypath)

  require('lazy').setup(require('nvim.lazy.spec'), {
    dev = {
      path = vim.g.plug_home,
      fallback = true,
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

M.spec = {
  { 'folke/lazy.nvim' },
  { 'LazyVim/LazyVim' },
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

return M
