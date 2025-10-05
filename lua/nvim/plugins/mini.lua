-- Configuration for individual mini.nvim submodules
-- Each can be independently enabled/disabled by setting enabled = false
--
-- To disable a specific submodule, set its enabled field to false:
--   icons = { enabled = false, ... },
--
-- Available submodules:
--   - icons: Icon support (required by other plugins like aerial.nvim)
--   - align: Text alignment with 'ga' operator
--   - ai: Extended text objects for more intuitive selections
--   - diff: Git diff integration with inline signs
--   - hipatterns: Highlight patterns (e.g., hex colors)
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
    -- Setup mini.icons first (required by other plugins)
    if submodules.icons and submodules.icons.enabled then
      submodules.icons.config()
    end

    -- Load remaining enabled submodules (deferred to ensure dependencies are ready)
    vim.schedule(function()
      for name, submod in pairs(submodules) do
        if name ~= 'icons' and submod.enabled then
          submod.config()
        end
      end
    end)
  end,
}
