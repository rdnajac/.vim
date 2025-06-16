return {
  {
    'folke/which-key.nvim',
    ---@class wk_opts
    opts = {
      keys = { scroll_down = '<C-j>', scroll_up = '<C-k>' },
      preset = 'helix',
      show_help = false,
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

          { '<leader>x', group = 'diagnostics/quickfix', icon = { icon = '󱖫 ', color = 'green' } },
          {
            icon = { icon = ' ', color = 'green' },
            -- { '<leader>r' },
            { '<leader>v', group = 'vimrc' },
            { '<leader>E' },
            { '<leader>m' },
            { '<leader>w' },
            { '<leader>i' },
            { '<leader>t' },
            { '<leader>ft', desc = 'filetype plugin' },
            { '<leader>fs', desc = 'filetype snippets' },
          },
          {
            icon = { icon = '󰢱 ', color = 'blue' },
            { '<leader>fT', desc = 'filetype plugin (.lua)' },
          },
          -- { '<localleader>l', group = 'vimtex' },
        },
        { hidden = true, { 'g~' }, { 'g#' }, { 'g*' } },
      },
    },
  },
  {
    'folke/trouble.nvim',
    cmd = { 'Trouble' },
    opts = {
      modes = {
        lsp = {
          win = { position = 'right' },
        },
      },
    },
    keys = {
      { '<leader>xx', '<Cmd>Trouble diagnostics toggle<CR>', desc = 'Diagnostics (Trouble)' },
      { '<leader>xX', '<Cmd>Trouble diagnostics toggle filter.buf=0<CR>', desc = 'Buffer Diagnostics (Trouble)' },
      { '<leader>cs', '<Cmd>Trouble symbols toggle<CR>', desc = 'Symbols (Trouble)' },
      { '<leader>cS', '<Cmd>Trouble lsp toggle<CR>', desc = 'LSP references/definitions/... (Trouble)' },
      { '<leader>xL', '<Cmd>Trouble loclist toggle<CR>', desc = 'Location List (Trouble)' },
      { '<leader>xQ', '<Cmd>Trouble qflist toggle<CR>', desc = 'Quickfix List (Trouble)' },
      {
        '[q',
        function()
          if require('trouble').is_open() then
            require('trouble').prev({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = 'Previous Trouble/Quickfix Item',
      },
      {
        ']q',
        function()
          if require('trouble').is_open() then
            require('trouble').next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = 'Next Trouble/Quickfix Item',
      },
    },
  },
  {
    'folke/todo-comments.nvim',
    event = 'LazyFile',
    opts = {},
    -- stylua: ignore
    keys = {
      { ']t', function() require('todo-comments').jump_next() end, desc = 'Next Todo Comment', },
      { '[t', function() require('todo-comments').jump_prev() end, desc = 'Previous Todo Comment', },
      { '<leader>xt', '<Cmd>Trouble todo toggle<CR>', desc = 'Todo (Trouble)' },
      { '<leader>xT', '<Cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<CR>', desc = 'Todo/Fix/Fixme (Trouble)', },
    },
  },
}
