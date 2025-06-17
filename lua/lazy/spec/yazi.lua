return {
  'mikavilpas/yazi.nvim',
  event = 'VeryLazy',
  -- stylua: ignore
  keys = {
    { '<leader>-',  '<Cmd>Yazi<CR>',        desc = 'Open yazi at the current file',                     },
    { '<leader>cw', '<Cmd>Yazi cwd<CR>',    desc = 'Open yazi at the current dir', },
    { '<leader>_',  '<Cmd>Yazi toggle<CR>', desc = 'Resume the last yazi session',                      },
  },
  ---@type YaziConfig
  opts = {
    open_for_directories = false,
    keymaps = {
      show_help = '<F1>',
      -- TODO: on delete, d to confirm
    },
    floating_window_scaling_factor = 1,
    yazi_floating_window_border = 'none',
  },
}
