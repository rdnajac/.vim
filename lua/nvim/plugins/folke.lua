return {
  {
    'folke/sidekick.nvim',
    lazy = true,
    --- @type sidekick.Config
    opts = {},
    after = function()
      vim.lsp.enable('copilot')
      vim.lsp.inline_completion.enable()
      Snacks.toggle({
        name = 'Inline Completion',
        get = function()
          return vim.lsp.inline_completion.is_enabled()
        end,
        set = function(state)
          vim.lsp.inline_completion.enable(state)
        end,
      }):map('<leader>ai')
    end,
  -- stylua: ignore
      keys = {
      -- nes is also useful in normal mode
      { mode = 'n', '<Tab>',
        function() -- if there is a next edit, jump to it, otherwise apply it if any
          if not require('sidekick').nes_jump_or_apply() then
            return '<Tab>' -- fallback to normal tab
          end
        end,
        expr = true,
        desc = "Goto/Apply Next Edit Suggestion",
      },
      { '<leader>a', '', desc = '+ai', mode = { 'n', 'v' } },
      { '<leader>aa', function() require('sidekick.cli').toggle('copilot') end, desc = 'Sidekick Toggle CLI' },
      { '<leader>ap', function() require('sidekick.cli').prompt() end, mode = { 'n', 'v' }, desc = 'Sidekick Select Prompt'  },
      { '<leader>as', function() require('sidekick.cli').send()   end, mode = { 'v' }, desc = 'Sidekick Send Visual Selection' },
      { '<leader>at', function() require('sidekick.cli').send({msg='{this}'}) end, mode = { 'n', 'x' }, desc = 'Send This' },
      { '<leader>av', function() require('sidekick.cli').send({msg='{selection}'}) end, mode = { 'x' }, desc = 'Send Visual Selection' },
      { '<C-.>',      function() require('sidekick.cli').focus() end,    mode = { 'n', 't', 'i', 'x' }, desc = 'Sidekick Switch Focus' },
    },
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
    lazy = true,
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
-- vim:foldlevel=1:foldmethod=expr
