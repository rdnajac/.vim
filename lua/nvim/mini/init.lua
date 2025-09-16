return {
  'nvim-mini/mini.nvim',
  lazy = true,
  config = function()
    require('nvim.util').for_each_module(function(minimod)
      require(minimod)
    end, 'nvim/mini')
    -- just call these manually for now
    require('mini.align').setup({})
    require('mini.icons').setup(nv.mini.icons)
  end,
}
