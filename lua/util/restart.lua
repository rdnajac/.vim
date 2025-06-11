-- TODO: this should be a command, then delete after/plugin/restart.lua
local sesh = vim.fn.stdpath('config') .. '/Session.vim'

vim.api.nvim_create_autocmd('VimEnter', {
  group = vim.api.nvim_create_augroup('RestoreSession', { clear = true }),
  callback = function()
    if vim.fn.filereadable(sesh) == 1 then
      vim.cmd('source ' .. vim.fn.fnameescape(sesh))
      vim.fn.delete(sesh)
      if vim.fn.filereadable(vim.fn.expand('%')) == 1 then
        vim.fn.timer_start(1, function()
          vim.cmd('edit')
        end)
      end
    end
  end,
})

vim.cmd('mksession! ' .. vim.fn.fnameescape(sesh))
vim.cmd('restart')
