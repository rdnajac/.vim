return {
  'olimorris/codecompanion.nvim',
  specs = { 'nvim-lua/plenary.nvim' },
  enabled = false,
  opts = {},
  after = function()
    vim.cmd([[ delcommand PlenaryBustedDirectory | delcommand PlenaryBustedFile ]])
  end,
}
