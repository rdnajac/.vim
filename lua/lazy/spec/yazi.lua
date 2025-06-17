return {
  'mikavilpas/yazi.nvim',
  event = 'VeryLazy',
  -- stylua: ignore
  keys = {
    { '-',          '<cmd>Yazi<cr>',        desc = 'Open yazi at the current file',                     },
    { '<leader>cw', '<cmd>Yazi cwd<cr>',    desc = 'Open yazi at the current dir', },
    { '<c-up>',     '<cmd>Yazi toggle<cr>', desc = 'Resume the last yazi session',                      },
  },
  ---@type YaziConfig
  opts = {
    open_for_directories = true,
    keymaps = {
      show_help = '<F1>',
      -- TODO: on delete, d to confirm
    },
    floating_window_scaling_factor = 1,
    yazi_floating_window_border = 'none',
  },
  -- init = function()
  --   -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
  --   -- vim.g.loaded_netrw = 1
  --   vim.g.loaded_netrwPlugin = 1
  -- end,
}
