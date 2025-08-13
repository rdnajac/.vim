return {
  'b0o/incline.nvim',
  config = function()
    require('incline').setup({
      render = require('vimline').incline,
    })
  end,
  event = 'BufWinEnter',
}
