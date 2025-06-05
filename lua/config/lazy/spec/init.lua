vim.g.lazyvim_check_order = false

return {
  {
    'LazyVim/LazyVim',
    opts = {
      defaults = {
        autocmds = false,
        keymaps = false,
      },
      news = {
        lazyvim = true,
        neovim = true,
      },
    },
    { import = 'lazyvim.plugins.init' },
  },
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
      notifier = { style = 'fancy', date_format = '%T', timeout = 4000 },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      terminal = {
        start_insert = true,
        auto_insert = false,
        auto_close = true,
        win = { wo = { winbar = '', winhighlight = 'Normal:SpecialWindow' } },
      },
      words = { enabled = true },
      ---@class snacks.picker.Config
      picker = {
        layouts = {
          vscode = {
            layout = {
              backdrop = false,
              row = 1,
              width = 0.4,
              min_width = 80,
              height = 0.4,
              -- border = 'rounded',
              box = 'vertical',
              {
                win = 'input',
                height = 1,
                -- border = 'rounded',
                title = '{title} {live} {flags}',
                title_pos = 'center',
              },
              { win = 'list', border = 'none' },
            },
          },
        },
        win = { preview = { minimal = true } },
        sources = {
          -- command_history = { layout = { preset = 'vscode' }, confirm = 'cmd' },
          autocmds = { layout = { preset = 'ivy_split' }, confirm = 'edit' },
          buffers = { layout = { preset = 'vscode' } },
          commands = { layout = { preset = 'ivy' } },
          files = { layout = { preset = 'sidebar' } },
          grep = { layout = { preset = 'ivy' }, follow = true, ignored = true },
          help = { layout = { preset = 'vscode' } },
          keymaps = { layout = { preset = 'ivy_split' }, confirm = 'edit' },
          notifications = { layout = { preset = 'ivy_split' }, confirm = 'edit' },
          pickers = { layout = { preset = 'vscode' } },
          zoxide = {
            layout = { preset = 'vscode' },
            confirm = { 'edit' },
            --      confirm = function(self, item)
            --        local dir = item.path or item.filename or item.value or item.text
            --        if type(dir) ~= 'string' or dir == '' then
            --          vim.notify('No valid directory found', vim.log.levels.WARN)
            --          return
            --        end
            --        local win = vim.api.nvim_get_current_win()
            --
            --        vim.cmd('leftabove vsplit ' .. vim.fn.fnameescape(dir))
            --        vim.cmd('vertical resize ' .. math.floor(vim.o.columns * 0.2))
            --        vim.cmd('cd ' .. vim.fn.fnameescape(dir))
            -- vim.cmd('pwd')
            --        vim.api.nvim_set_current_win(win)
            --      end,
          },
        },
      },
    },
  },
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
      sort = { 'order', 'alphanum', 'mod' },
      spec = {
        {
          mode = { 'n' },
          { '<localleader>l', desc = '+vimtex' },
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
