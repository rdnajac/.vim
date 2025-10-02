return {
  {
    'folke/which-key.nvim',
    --- @module "which-key"
    --- @class wk.Opts
    opts = {
      keys = { scroll_down = '<C-j>', scroll_up = '<C-k>' },
      preset = 'helix',
      show_help = false,
      sort = { 'order', 'alphanum', 'case', 'mod' },
      spec = {
        {
          {
            mode = { 'n', 'v' },
            -- TODO: add each bracket mapping manually
            { '[', group = 'prev' },
            { ']', group = 'next' },
            { 'g', group = 'goto' },
            { 'z', group = 'fold' },
          },

          mode = { 'n' },
          -- TODO: add the other groups
          { 'co', group = 'comment below' },
          { 'cO', group = 'comment above' },
          { '<leader>dp', group = 'profiler' },
          { '<leader>u', group = 'ui' },
          { '<leader>x', group = 'diagnostics/quickfix' },
          { '<localleader>l', group = 'vimtex' },

          -- descriptions
          { 'gx', desc = 'Open with system app' },
        },
        { hidden = true, { 'g~' }, { 'g#' }, { 'g*' } },
      },
    },
    after = function()
      local registers = '*+"-:.%/#=_0123456789'
      require('which-key.plugins.registers').registers = registers
    end,
  },
  {
    'folke/noice.nvim',
    enabled = false,
    opts = {
      lsp = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      routes = {
        {
          filter = {
            event = 'msg_show',
            any = {
              { find = '%d+L, %d+B' },
              { find = '; after #%d+' },
              { find = '; before #%d+' },
            },
          },
          view = 'mini',
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
    },
  },
  {
    'folke/flash.nvim',
    enabled = false,
    opts = {},
    -- stylua: ignore
    keys = {
      { 'gj', mode = { 'n', 'o', 'x' }, function() require('flash').jump() end,       desc = 'Flash'                    },
      { 's',  mode = { 'n', 'o', 'x' }, function() require('flash').treesitter() end, desc = 'Flash Treesitter'         },
      { 'J',  mode = {           'x' }, function() require('flash').remote() end,     desc = 'Remote Flash'             },
      { 'R',  mode = {      'o', 'x' }, function() require('flash').treesitter_search() end, desc = 'Treesitter Search' },
      -- { '<C-s>', mode = { 'c' }, function() require('flash').toggle() end, desc = 'Toggle Flash Search' },
    },
    after = function()
      vim.keymap.set({ 'n', 'o', 'x' }, '<C-Space>', function()
        require('flash').treesitter({
          actions = {
            ['<C-Space>'] = 'next',
            ['<BS>'] = 'prev',
          },
        })
      end, { desc = 'Treesitter incremental selection' })
    end,
  },
  {
    'folke/todo-comments.nvim',
    opts = {},
    -- stylua: ignore
    keys = {
      -- TODO: check against vim-unimpaired
      -- { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
      -- { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
      { '<leader>st', function() Snacks.picker.todo_comments() end, desc = 'Todo' },
      -- TODO: use snacks picker instead
      -- { '<leader>sT', '<cmd>TodoTelescope keywords=TODO,FIXME<CR>', desc = 'Todo/Fixme' },
    },
    after = function()
      for _, cmd in ipairs({ 'TodoFzfLua', 'TodoLocList', 'TodoQuickFix', 'TodoTelescope' }) do
        vim.cmd.delcommand(cmd)
      end
    end,
  },
  {
    'folke/trouble.nvim',
    enabled = false,
    opts = {},
    -- stylua: ignore
    keys = {
      { '<leader>xt', '<cmd>Trouble todo toggle<CR>', desc = 'Todo (Trouble)' },
      { '<leader>xT', '<cmd>Trouble todo toggle filter = {tag = {TODO,FIXME}}<CR>', desc = 'Todo/Fix/Fixme (Trouble)' },
      { '<leader>xx', '<Cmd>Trouble diagnostics toggle<CR>', desc = 'Diagnostics (Trouble)' },
      { '<leader>xX', '<Cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
      { '<leader>cs', '<Cmd>Trouble symbols toggle<CR>', desc = 'Symbols (Trouble)' },
      { '<leader>cS', '<Cmd>Trouble lsp     toggle<CR>', desc = 'LSP references/definitions/... (Trouble)' },
      { '<leader>xL', '<Cmd>Trouble loclist toggle<CR>', desc = 'Location List (Trouble)' },
      { '<leader>xQ', '<Cmd>Trouble qflist  toggle<CR>', desc = 'Quickfix List (Trouble)' },
      -- TODO: check against vim-unimpaired
      -- {
      --   '[q',
      --   function()
      --     if require('trouble').is_open() then
      --       require('trouble').prev({ skip_groups = true, jump = true })
      --     else
      --       local ok, err = pcall(vim.cmd.cprev)
      --       if not ok then
      --         vim.notify(err, vim.log.levels.ERROR)
      --       end
      --     end
      --   end,
      --   desc = 'Previous Trouble/Quickfix Item',
      -- },
      -- {
      --   ']q',
      --   function()
      --     if require('trouble').is_open() then
      --       require('trouble').next({ skip_groups = true, jump = true })
      --     else
      --       local ok, err = pcall(vim.cmd.cnext)
      --       if not ok then
      --         vim.notify(err, vim.log.levels.ERROR)
      --       end
      --     end
      --   end,
      --   desc = 'Next Trouble/Quickfix Item',
      -- },
    },
  },
  {
    'folke/ts-comments.nvim',
    enabled = false,
    opts = {},
  },
  {
    'folke/lazydev.nvim',
    enabled = true,
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        -- { path = "LazyVim", words = { "LazyVim" } },
        { path = 'snacks.nvim', words = { 'Snacks' } },
        -- { path = "lazy.nvim", words = { "LazyVim" } },
      },
    },
  },
}
-- vim:fdm=expr:fdl=2
