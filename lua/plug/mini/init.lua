local M = { 'nvim-mini/mini.nvim' }

package.preload['nvim-web-devicons'] = function()
  require('mini.icons').mock_nvim_web_devicons()
  return package.loaded['nvim-web-devicons']
end

M.config = function()
  require('util').for_each_module(function(minimod)
    require(minimod)
  end, 'plug/mini')
end

M.event = 'BufWinEnter'

return M
