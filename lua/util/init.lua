vim.keymap.set('n', '<leader>cd', function()
  vim.ui.input({ prompt = 'Change Directory: ', default = vim.fn.getcwd() }, function(input)
    if input then
      vim.cmd('cd ' .. input)
    end
    vim.cmd('pwd')
  end)
end, { desc = 'Change Directory' })

vim.keymap.set('n', '<leader>q', function()
  if #vim.fn.getbufinfo({ buflisted = 1 }) > 1 then
    -- vim.cmd('bdelete')
    Snacks.bufdelete()
  else
    vim.cmd('quit')
  end
end, { desc = 'Smart Quit' })

vim.keymap.set('n', '~', function()
  local cwd = vim.fn.getcwd()
  local target = vim.fn.expand('%:p:h')
  if cwd == target then
    target = require('lazyvim.util').root.get()
  end
  vim.cmd('cd ' .. target .. ' | pwd')
end)
