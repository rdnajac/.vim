local lazy_file_events = { 'BufReadPost', 'BufNewFile', 'BufWritePre' }
local triggered = false

vim.api.nvim_create_autocmd(lazy_file_events, {
  group = vim.api.nvim_create_augroup('LazyFile', { clear = true }),
  callback = function()
    if triggered then
      return
    end
    triggered = true
    vim.api.nvim_exec_autocmds('User', { pattern = 'LazyFile' })
  end,
  desc = 'User LazyFile event from LazyVim',
})

local M = {}

M.spec = {
  { 'LazyVim/LazyVim' },
  {
    'folke/lazydev.nvim',
    opts = {
      library = {
        -- { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        { path = 'LazyVim', words = { 'LazyVim' } },
        { path = 'snacks.nvim', words = { 'Snacks' } },
        -- -- { path = "lazy.nvim", words = { "LazyVim" } },
        { path = 'mini.nvim', words = { 'Mini.*' } },
        { path = 'nvim', words = { 'nv' } },
      },
    },
  },
}

return M
