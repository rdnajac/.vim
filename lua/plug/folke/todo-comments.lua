return {
  'folke/todo-comments.nvim',
  enabled = true,
  opts = {},
  config = function()
    require('todo-comments').setup({})
  end,
}
