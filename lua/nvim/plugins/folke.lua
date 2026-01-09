return {
  -- { 'folke/lazy.nvim' },
  -- { 'LazyVim/LazyVim' },
  {
    'folke/lazydev.nvim',
    opts = {
      library = {
        -- PERF: no longer necessary witH `$VIMRUNTIME/lua/uv/_meta.lua`
        -- { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        -- { path = 'LazyVim', words = { 'LazyVim' } },
        { path = 'snacks.nvim', words = { 'Snacks' } },
        -- { path = 'lazy.nvim', words = { 'LazyVim' } },
        { path = 'mini.nvim', words = { 'Mini.*' } },
        { path = 'nvim', words = { 'nv' } },
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
      -- stylua: ignore
      { '<leader>st', function() Snacks.picker.todo_comments() end, desc = 'Todo' },
    },
    after = function() end,
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
