return {
  {
    'folke/todo-comments.nvim',
    enabled = true,
    opts = function()
      vim.schedule(function()
        local cmds = { 'TodoFzfLua', 'TodoLocList', 'TodoQuickFix', 'TodoTelescope' }
        for _, cmd in ipairs(cmds) do
          -- vim.cmd.delcommand(cmd)
          vim.api.nvim_del_user_command(cmd)
        end
      end)
      -- Section: rv
      return {
        keywords = { Section = { icon = '󰚟', color = 'title' } },
        -- highlight = { keyword = 'bg', },
        colors = {
          title = { '#7DCFFF' },
          error = { '#DC2626' },
          warning = { 'DiagnosticWarn', 'WarningMsg', '#FBBF24' },
          info = { 'DiagnosticInfo', '#2563EB' },
          hint = { 'DiagnosticHint', '#10B981' },
          default = { 'Identifier', '#7C3AED' },
          test = { 'Identifier', '#FF00FF' },
        },
      }
    end,
    keys = {
      -- TODO: rewrite without this plugin
      { '<leader>st', function() Snacks.picker.todo_comments() end, desc = 'Todo' },
    },
  },
  {
    'folke/edgy.nvim',
    enabled = false,
    lazy = true,
    opts = {
      wo = {
        -- Setting to `true`, will add an edgy winbar.
        -- Setting to `false`, won't set any winbar.
        -- Setting to a string, will set the winbar to that string.
        winbar = true,
        winfixwidth = true,
        winfixheight = false,
        winhighlight = 'WinBar:EdgyWinBar,Normal:EdgyNormal',
        spell = false,
        signcolumn = 'yes',
      },
    },
      -- stylua: ignore
    keys = {
      {'<leader>ue', function() require('edgy').toggle() end, desc = 'Edgy Toggle',},
      {'<leader>uE', function() require('edgy').select() end, desc = 'Edgy Select Window',},
    },
  },
  {
    'folke/flash.nvim',
    enabled = false,
    opts = function()
      vim.schedule(function()
        vim.keymap.set(
          { 'n', 'o', 'x' },
          '<C-Space>',
          function()
            require('flash').treesitter({
              actions = {
                ['<C-Space>'] = 'next',
                ['<BS>'] = 'prev',
              },
            })
          end,
          { desc = 'Treesitter incremental selection' }
        )
      end)
      return {}
    end,
    -- stylua: ignore
    keys = {
      { 'gj', mode = { 'n', 'o', 'x' }, function() require('flash').jump() end,       desc = 'Flash'                    },
      { 's',  mode = { 'n', 'o', 'x' }, function() require('flash').treesitter() end, desc = 'Flash Treesitter'         },
      { 'R',  mode = {      'o', 'x' }, function() require('flash').treesitter_search() end, desc = 'Treesitter Search' },
      { 'J',  mode = {           'x' }, function() require('flash').remote() end,     desc = 'Remote Flash'             },
      -- { '<C-s>', mode = { 'c' }, function() require('flash').toggle() end, desc = 'Toggle Flash Search' },
    },
  },
  {
    'folke/noice.nvim',
    enabled = false,
    opts = {
      -- lsp = {
      --   override = {
      --     ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      --     ['vim.lsp.util.stylize_markdown'] = true,
      --     ['cmp.entry.get_documentation'] = true,
      --   },
      -- },
      -- routes = {
      --   {
      --     filter = {
      --       event = 'msg_show',
      --       any = {
      --         { find = '%d+L, %d+B' },
      --         { find = '; after #%d+' },
      --         { find = '; before #%d+' },
      --       },
      --     },
      --     view = 'mini',
      --   },
      -- },
      presets = {
        bottom_search = true,
        command_palette = true,
        -- long_message_to_split = true,
      },
    },
  },
  {
    'folke/trouble.nvim',
    enabled = false,
    opts = {},
  },
}
-- vim: fdl=1 fdm=expr
