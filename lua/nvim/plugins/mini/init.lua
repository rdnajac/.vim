local M = { 'echasnovski/mini.nvim' }

package.preload['nvim-web-devicons'] = function()
  require('mini.icons').mock_nvim_web_devicons()
  return package.loaded['nvim-web-devicons']
end

M.event = 'BufWinEnter'

M.config = function()
  require('mini.align').setup({})
  require('nvim.plugins.mini.ai')
  require('nvim.plugins.mini.icons')
  require('nvim.plugins.mini.hipatterns')
  require('nvim.plugins.mini.diff')
  -- require('plugins.mini.splitjoin')
end

return M
