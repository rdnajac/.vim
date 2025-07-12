local M = { 'echasnovski/mini.nvim' }

vim.cmd('packadd mini.nvim')

package.preload['nvim-web-devicons'] = function()
  require('mini.icons').mock_nvim_web_devicons()
  return package.loaded['nvim-web-devicons']
end

M.config = function()
  -- lazyload(function()
  require('plugins.mini.ai')
  require('plugins.mini.icons')
  require('plugins.mini.hipatterns')
  -- require('plugins.mini.diff')
  -- end)
end

return M
