return {
  'nvim-mini/mini.nvim',
  event = 'BufWinEnter',
  config = function()
    require('nvim.util').for_each_module(function(minimod)
      require(minimod)
    end, 'nvim/mini')
  end,
}
