local M = { 'nvim-mini/mini.nvim' }

M.config = function()
  require('util').for_each_module(function(minimod)
    require(minimod)
  end, 'nvim/mini')
end

M.event = 'BufWinEnter'

return M
