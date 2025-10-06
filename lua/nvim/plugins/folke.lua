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
            -- going through all of the nvim defaults and the ones provided by unimpaired
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
    opts = {
      keywords = { Section = { icon = '󰚟', color = 'title' } },
      -- highlight = { keyword = 'bg', },
      colors = { title = { '#7DCFFF' } },
    },
    keys = {
      -- stylua: ignore
      { '<leader>st', function() Snacks.picker.todo_comments() end, desc = 'Todo' },
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
