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
      sort = { 'order', 'case', 'alphanum', 'mod' },
      spec = {
        {
          mode = { 'n' },
          { '<localleader>l', group = '+vimtex' },
          { '<localleader>r', group = '+R', icon = { icon = ' ', color = 'blue' } },

          -- add icons for existing (vim) keymaps
          { '<leader>a', icon = { icon = ' ', color = 'azure' }, desc = 'Select All' },
          { '<leader>r', icon = { icon = ' ', color = 'azure' } },
          { '<leader>v', icon = { icon = ' ', color = 'azure' } },
          { '<leader>ft', icon = { icon = ' ', color = 'azure' } },
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
          -- TODO: add unimpaired toggles
          -- yob	'background' (dark is off, light is on)
          -- yoc	'cursorline'
          -- yod	'diff' (actually |:diffthis| / |:diffoff|)
          -- yoh	'hlsearch'
          -- yoi	'ignorecase'
          -- yol	'list'
          -- yon	'number'
          -- yor	'relativenumber'
          -- yos	'spell'
          -- yot	'colorcolumn' ("+1" or last used value)
          -- you	'cursorcolumn'
          -- yov	'virtualedit'
          -- yow	'wrap'
          -- yox	'cursorline' 'cursorcolumn' (x as in crosshairs)
        },
        mode = { 'n', 'v' },
        { '[', group = 'prev' },
        { ']', group = 'next' },
        { 'g', group = 'goto' },
        { 'z', group = 'fold' },

        -- better descriptions
        { 'gx', desc = 'Open with system app' },

        -- nvim lsp defaults
        {
          icon = { icon = ' ', color = 'orange' },
          { 'gr', group = 'LSP' },
          { 'gO' },
        },

        -- keep things tidy
        { 'g~', hidden = true },
        { 'gc', hidden = true },
      },
    },
  },
}
