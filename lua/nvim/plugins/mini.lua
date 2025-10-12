local minimods = {
  -- 'icons',
  'align',
  'ai',
  'diff',
  'hipatterns',
  -- 'splitjoin',
  -- 'surround',
}

return {
  'nvim-mini/mini.nvim',
  keys = {
    { 'ga', mode = 'x', desc = 'Align (mini)' },
    { 'gA', mode = 'x', desc = 'Align (mini with preview)' },
  },
  config = function()
    -- local extra_icons = require('nvim.config.icons').mini
    -- require('mini.icons').setup(nv.icons.mini)
    require('mini.icons').setup()

    vim.schedule(function()
      for _, mod in ipairs(minimods) do
        require('nvim.plugins.mini.' .. mod)
        -- require('mini.' .. mod).setup({})
      end
    end)
  end,
}
