local M = {}

M.specs = {
  'folke/todo-comments.nvim',
  -- 'folke/noice.nvim',
  -- 'jhui/fidget.nvim',
}

M.config = function()
  require('todo-comments').setup({})
  require('ui.winbar')
end

return M
