return {
  specs = {
    'folke/todo-comments.nvim',
    'folke/trouble.nvim',
  },
  config = function()
    require('todo-comments').setup()
    require('trouble').setup()
  end,
}
