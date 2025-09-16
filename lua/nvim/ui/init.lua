local M = vim.defaulttable(function(k)
  return require('ui.' .. k)
end)

vim.o.cmdheight = 0
vim.o.laststatus = 3
vim.o.pumblend = 0
-- vim.o.smoothscroll = true
vim.o.winborder = 'rounded'

vim.o.winbar = '%{%v:lua.MyWinBar()%}'

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

-- TODO: make default tables set these values to empty tables so
-- the loading mechanism stops freaking out
M.keys = {}
function M.after() end

return M
