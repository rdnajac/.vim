return {
  enabled = true,
  'stevearc/aerial.nvim',
  opts = {},
  after = function()
    Snacks.util.on_module('mini.icons', function()
      MiniIcons.mock_nvim_web_devicons()
    end)
  end,
}
