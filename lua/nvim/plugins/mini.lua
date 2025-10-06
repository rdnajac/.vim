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
    require('mini.icons').setup(nv.icons.mini)

    vim.schedule(function()
      for _, mod in ipairs(minimods) do
        local ok, _ = pcall(require, 'nvim.plugins.mini.' .. mod)
        if not ok then
          require('mini.' .. mod).setup({})
        else
          -- print('loaded custom mini.' .. mod)
        end
      end
    end)
  end,
}
