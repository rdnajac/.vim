local M = {
  lazy_file_events = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
}

local triggered = false

M.setup = function()
  vim.api.nvim_create_autocmd(M.lazy_file_events, {
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
end

return M
