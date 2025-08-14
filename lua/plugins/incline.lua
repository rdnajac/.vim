return {
  'b0o/incline.nvim',
  config = function()
    require('incline').setup({
      render = require('vimline').incline,
      ignore = {
        buftypes = {
          'acwrite',
          'nofile',
          'nowrite',
          'prompt',
          'quickfix',
        },
      },
    })
  end,
  event = 'BufWinEnter',
}
