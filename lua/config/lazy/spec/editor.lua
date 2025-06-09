return {
  {
    'folke/which-key.nvim',
    ---@class wk_opts
    opts = {
      show_help = false,
      keys = {
        scroll_down = '<C-j>',
        scroll_up = '<C-k>',
      },
      preset = 'helix',
      sort = { 'order', 'alphanum', 'case', 'mod' },
      spec = {
        {
          {
            mode = { 'n', 'v' },
            { '[', group = 'prev' },
            { ']', group = 'next' },
            { 'g', group = 'goto' },
            { 'z', group = 'fold' },
          },

          mode = { 'n' },
          {
            '<leader>b',
            group = 'buffer',
            expand = function()
              return require('which-key.extras').expand.buf()
            end,
          },
          {
            '<c-w>',
            group = 'windows',
            expand = function()
              return require('which-key.extras').expand.win()
            end,
          },
          {
            icon = { icon = ' ', color = 'green' },
            { '<leader>r' },
            { '<leader>v' },
            { '<leader>ft', desc = 'filetype plugin' },
            { '<leader>fs', desc = 'filetype snippets' },
          },
          { '<localleader>l', group = 'vimtex' },
          { '<localleader>r', group = 'R', icon = { icon = ' ', color = 'blue' } },
        },
        {
          hidden = true,
          { 'g~' },
          { 'g#' },
          { 'g*' },
        },
      },
    },
  },
}
