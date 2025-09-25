return {
  'nvim-mini/mini.nvim',
  lazy = true,
  config = function()
    -- require('mini.extra').setup()
    require('mini.align').setup({})
    require('mini.icons').setup(nv.mini.icons)
    require('nvim.mini.ai')
    require('nvim.mini.diff')
    require('nvim.mini.hipatterns')
  end,
  -- icon = 
}
