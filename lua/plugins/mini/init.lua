local M = { 'echasnovski/mini.nvim' }

package.preload['nvim-web-devicons'] = function()
  require('mini.icons').mock_nvim_web_devicons()
  return package.loaded['nvim-web-devicons']
end

M.event = 'BufWinEnter'

M.config = function()
  require('mini.align').setup({})
  require('plugins.mini.ai')
  require('plugins.mini.icons')
  require('plugins.mini.hipatterns')
  require('plugins.mini.diff')
  -- require('nvim.plugins.mini.splitjoin')
  -- vim.pack.add({ 'https://github.com/AndrewRadev/splitjoin.vim' })
end

return M
