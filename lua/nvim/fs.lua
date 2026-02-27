return {
  after = function() end,
  specs = {
    {
      'stevearc/oil.nvim',
      enabled = true,
      keys = { { '-', '<Cmd>Oil<CR>' } },
      opts = {
        default_file_explorer = false,
      },
    },
  },
}
