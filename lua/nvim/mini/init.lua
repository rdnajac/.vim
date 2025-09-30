return {
  'nvim-mini/mini.nvim',
  config = function()
    local extra_icons = require('nvim.config.icons').mini
    require('mini.icons').setup(nv.icons.mini)

    vim.schedule(function()
      require('mini.align').setup({})
      require('nvim.mini.ai')
      require('nvim.mini.diff')
      require('nvim.mini.hipatterns')
    end)
  end,
}
