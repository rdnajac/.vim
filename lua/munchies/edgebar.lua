---@class snacks.win.Config: vim.api.keyset.win_config
Snacks.win({
  on_win = function(self)
    vim.cmd('Oil')
  end,
  position = 'left',
  width = 0.3,
  wo = {
    spell = false,
    wrap = false,
    signcolumn = 'yes',
    statuscolumn = ' ',
    conceallevel = 3,
  },
})
