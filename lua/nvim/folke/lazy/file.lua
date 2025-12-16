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
