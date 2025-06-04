return {
  {
    'folke/tokyonight.nvim',
    priority = 1001,
    opts = {
      style = 'night',
      dim_inactive = true,
      transparent = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = false, bold = true },
        sidebars = 'transparent',
        floats = 'transparent',
      },
      on_highlights = function(hl, _)
        hl['Folded'] = { fg = '#7aa2f7', bg = '#16161d' }
        hl['String'] = { fg = '#39ff14' }
        hl['SpecialWindow'] = { bg = '#1f2335' }
        -- hl['NormalFloat'] = { bg = '#1f2335' }
        hl['SpellBad'] = { bg = '#ff0000' }
        hl['CopilotSuggestion'] = { bg = '#414868', fg = '#7AA2F7' }
      end,
    },
  },
  {
    'folke/snacks.nvim',
    priority = 1000,
    opts = {
      bigfile = { enabled = true },
      dashboard = require('munchies.dashboard').opts,
      explorer = { enabled = false },
      image = { enabled = true },
      indent = { indent = { only_current = true, only_scope = true } },
      input = { enabled = true },
      notifier = { enabled = false },
      -- notifier = { style = 'fancy', date_format = '%T', timeout = 3000 },
      picker = require('munchies.picker').opts,
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      -- statuscolumn = { left = { 'sign' }, right = { 'git' } },
      terminal = {
        start_insert = true,
        auto_insert = false,
        auto_close = true,
        win = { wo = { winbar = '', winhighlight = 'Normal:SpecialWindow' } },
      },
      words = { enabled = true },
    },
  },
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      show_help = false,
      keys = {
        scroll_down = '<C-j>',
        scroll_up = '<C-k>',
      },
      preset = 'helix',
      sort = { 'order', 'alphanum', 'mod' },
      spec = {
        {
          mode = { 'n' },
          -- { '<localleader>l', desc = '+vimtex' },
          -- { '<localleader>r', group = '+R', icon = { icon = ' ', color = 'blue' } },
          -- { '<localleader>re', group = '++renv' },

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
        -- { 'grn' }

        -- keep things tidy
        { 'g~', hidden = true },
        { 'gc', hidden = true },

-- - "grn" is mapped in Normal mode to |vim.lsp.buf.rename()|
-- - "gra" is mapped in Normal and Visual mode to |vim.lsp.buf.code_action()|
-- - "grr" is mapped in Normal mode to |vim.lsp.buf.references()|
-- - "gri" is mapped in Normal mode to |vim.lsp.buf.implementation()|
-- - "gO" is mapped in Normal mode to |vim.lsp.buf.document_symbol()|
-- - CTRL-S is mapped in Insert mode to |vim.lsp.buf.signature_help()|
      },
    },
  },
}
