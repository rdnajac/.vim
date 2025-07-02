return {
  'echasnovski/mini.nvim',
  event = 'VeryLazy',
  init = function()
    package.preload['nvim-web-devicons'] = function()
      require('mini.icons').mock_nvim_web_devicons()
      return package.loaded['nvim-web-devicons']
    end
  end,
  config = function()
    require('lazy.spec.mini.ai')
    require('lazy.spec.mini.icons')
    require('lazy.spec.mini.hipatterns')
    require('mini.diff').setup({ view = { style = 'number', signs = { add = '▎', change = '▎', delete = '' } } })
  end,
}
