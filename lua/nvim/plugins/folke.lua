return {
  {
    'folke/edgy.nvim',
    enabled = false,
    lazy = true,
    opts = {
      right = {
        {
          title = 'Dirvish',
          ft = 'dirvish',
          -- size = { height = 0.5 },
        },
      },
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
    opts = {},
    -- stylua: ignore
    keys = {
      { 'gj', mode = { 'n', 'o', 'x' }, function() require('flash').jump() end,       desc = 'Flash'                    },
      { 's',  mode = { 'n', 'o', 'x' }, function() require('flash').treesitter() end, desc = 'Flash Treesitter'         },
      { 'R',  mode = {      'o', 'x' }, function() require('flash').treesitter_search() end, desc = 'Treesitter Search' },
      { 'J',  mode = {           'x' }, function() require('flash').remote() end,     desc = 'Remote Flash'             },
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
    -- enabled = false,
    lazy = true,
    opts = {
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
  { 'folke/ts-comments.nvim', enabled = false, opts = {} },
}
-- vim: fdl=1
