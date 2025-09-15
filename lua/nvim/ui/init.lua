local M = vim.defaulttable(function(k)
  return require('ui.' .. k)
end)

vim.o.cmdheight = 0
vim.o.laststatus = 3
vim.o.pumblend = 0
-- vim.o.smoothscroll = true
vim.o.winborder = 'rounded'

M.specs = {
  'folke/todo-comments.nvim',
  -- 'folke/noice.nvim',
  -- 'jhui/fidget.nvim',
}

M.config = function()
  require('nvim.ui.extui')
  require('nvim.ui.winbar')
  require('todo-comments').setup({})
end

return M
