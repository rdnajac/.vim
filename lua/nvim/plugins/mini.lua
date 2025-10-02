return {
  'nvim-mini/mini.nvim',
  -- init = function()
  --   package.preload['nvim-web-devicons'] = function()
  --     require('mini.icons').mock_nvim_web_devicons()
  --     return package.loaded['nvim-web-devicons']
  --   end
  -- end,
  config = function()
    local extra_icons = require('nvim.config.icons').mini
    require('mini.icons').setup(nv.icons.mini)

    vim.schedule(function()
      require('mini.align').setup({})
      require('nvim.plugins.mini.ai')
      require('nvim.plugins.mini.diff')
      require('nvim.plugins.mini.hipatterns')
    end)
  end,
}
