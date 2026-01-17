return {
  {
    'folke/sidekick.nvim',
    enabled = true,
    ---@type sidekick.Config
    opts = {
      cli = { win = { layout = 'float' } },
    },
    -- stylua: ignore
    keys = {
      -- TODO: 
      { mode = 'n', expr = true, '<Tab>',
        function() return
	  require('sidekick').nes_jump_or_apply() and '' or '<Tab>' 
	end,
      },
      { '<leader>a', group = 'ai', mode = { 'n', 'v' } },
      {
        '<leader>aa',
        function() require('sidekick.cli').toggle('copilot') end,
        desc = 'Sidekick Toggle CLI',
      },
      {
        '<leader>aA',
        function() require('sidekick.cli').toggle() end,
        desc = 'Sidekick Toggle CLI',
      },
      {
        '<leader>ad',
        function() require('sidekick.cli').close() end,
        desc = 'Detach a CLI Session',
      },
      {
        '<leader>ap',
        function() require('sidekick.cli').prompt() end,
        desc = 'Sidekick Select Prompt',
        mode = { 'n', 'x' },
      },
      {
        '<leader>at',
        function()
          local msg = vim.fn.mode():sub(1, 1) == 'n' and '{file}' or '{this}'
          require('sidekick.cli').send({ name = 'copilot', msg = msg })
        end,
        mode = { 'n', 'x' },
        desc = 'Send This (file/selection)',
      },
      {
        mode = { 'n', 't', 'i', 'x' },
        '<C-.>',
        function() require('sidekick.cli').toggle('copilot') end,
      },
    },
    toggles = {
      ['<leader>uN'] = {
        name = 'Sidekick NES',
        get = function() return require('sidekick.nes').enabled end,
        set = function(state) require('sidekick.nes').enable(state) end,
      },
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
    'folke/todo-comments.nvim',
    enabled = true,
    lazy = true,
    opts = function()
      local cmds = { 'TodoFzfLua', 'TodoLocList', 'TodoQuickFix', 'TodoTelescope' }
      for _, cmd in ipairs(cmds) do
        -- vim.cmd.delcommand(cmd)
        vim.api.nvim_del_user_command(cmd)
      end

      return {
        -- FIXME: extmarks not placed with statuscolun hook
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
      { '<leader>st', function() Snacks.picker.todo_comments() end, desc = 'Todo' },
    },
  },
  {
    'folke/trouble.nvim',
    enabled = false,
    opts = {},
    status = function()
      local trouble = require('trouble')
      local symbols = trouble.statusline({
        mode = 'symbols',
        groups = {},
        title = false,
        filter = { range = true },
        format = '{kind_icon}{symbol.name:Normal}',
        hl_group = 'lualine_c_normal',
      })
      return {
        symbols and symbols.get,
        cond = symbols.has,
      }
    end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    toggles = {
      ['<leader>um'] = {
        name = 'Render Markdown',
        get = function() return require('render-markdown.state').enabled end,
        set = function(state) require('render-markdown').set(state) end,
      },
    },
  },
}
-- vim: fdl=1 fdm=expr
