return {
  'folke/todo-comments.nvim',
  opts = {},
  after = function()
    -- FIXME: this doesn't work
    vim.cmd([[
  delcommand TodoFzfLua
  delcommand TodoLocList
  delcommand TodoQuickFix
  delcommand TodoTelescope
]])
  end,
}
