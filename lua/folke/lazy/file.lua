local M = {}

M.events = { 'BufReadPost', 'BufNewFile', 'BufWritePre' }

local triggered = false

M.setup = function()
  vim.api.nvim_create_autocmd(M.events, {
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
