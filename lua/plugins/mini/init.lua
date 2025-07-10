local M = { 'echasnovski/mini.nvim' }

M.init = function()
  package.preload['nvim-web-devicons'] = function()
    require('mini.icons').mock_nvim_web_devicons()
    return package.loaded['nvim-web-devicons']
  end
end

M.config = function()
  Lazy(function()
    require('plugins.mini.ai')
    require('plugins.mini.icons')
    require('plugins.mini.hipatterns')
    require('mini.diff').setup({
      view = { style = 'number', signs = { add = '▎', change = '▎', delete = '' } },
    })
  end)
end

return M
