-- Configuration for individual mini.nvim submodules
-- Each can be independently enabled/disabled
local submodules = {
  icons = {
    enabled = true,
    config = function()
      require('mini.icons').setup(nv.icons.mini)
    end,
  },
  align = {
    enabled = true,
    config = function()
      require('mini.align').setup({})
    end,
  },
  ai = {
    enabled = true,
    config = function()
      require('nvim.plugins.mini.ai')
    end,
  },
  diff = {
    enabled = true,
    config = function()
      require('nvim.plugins.mini.diff')
    end,
  },
  hipatterns = {
    enabled = true,
    config = function()
      require('nvim.plugins.mini.hipatterns')
    end,
  },
}

return {
  'nvim-mini/mini.nvim',
  config = function()
    -- Load enabled submodules
    for name, submod in pairs(submodules) do
      if submod.enabled then
        submod.config()
      end
    end
  end,
}
