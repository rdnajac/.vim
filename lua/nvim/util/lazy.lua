local M = {}

M.bootstrap = function(spec)
  local plugdir = vim.g.plughome
  local lazypath = vim.fs.joinpath(plugdir, 'lazy.nvim')
  vim.opt.rtp:prepend(lazypath)
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
end

M.file = function()
  local triggered = false
  local events = { 'BufReadPost', 'BufNewFile', 'BufWritePre' }

  vim.api.nvim_create_autocmd(events, {
    group = vim.api.nvim_create_augroup('LazyFile', { clear = true }),
    callback = function()
      if not triggered then
        triggered = true
        vim.api.nvim_exec_autocmds('User', { pattern = 'LazyFile' })
      end
    end,
    desc = 'User LazyFile event from LazyVim',
  })
end

return M
