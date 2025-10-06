return {
  {
    'stevearc/aerial.nvim',
    enabled = false,
    opts = {},
    after = function()
      Snacks.util.on_module('mini.icons', function()
        MiniIcons.mock_nvim_web_devicons()
      end)
    end,
  },
  {
    'stevearc/conform.nvim',
    enabled = false,
    opts = {},
  },
}
