return {
  -- { 'stevearc/conform.nvim', opts = {} },
  -- { 'stevearc/quicker.nvim', opts = {} },
  {
    'mason-org/mason.nvim',
    opts = {},
    -- TODO: implement one-time install func to hook into packinstall event
    once = function() vim.cmd.MasonInstall(nv.util.tools()) end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    init = function() require('nvim.ui.markdown') end,
  },
  {
    'folke/sidekick.nvim',
    -- BUG: `https://github.com/folke/sidekick.nvim/issues/264`
    -- enabled = false,
    opts = function()
      vim.schedule(vim.lsp.inline_completion.enable)
      return {
        -- tools = {
        -- BUG: https://github.com/folke/sidekick.nvim/issues/258
        -- copilot = { cmd = { 'copilot', '--banner', '--alt-screen' } },
        -- },
      }
    end,
    -- stylua: ignore
    keys = {
      { mode = 'n', expr = true, '<Tab>',
        function() return
	  require('sidekick').nes_jump_or_apply() and '' or '<Tab>'
	end
      },
      -- { '<leader>a', group = 'ai', mode = { 'n', 'v' } },
      { '<leader>aa', function() require('sidekick.cli').toggle('copilot') end, desc = 'Sidekick Toggle CLI', },
      { '<leader>aA', function() require('sidekick.cli').toggle() end, desc = 'Sidekick Toggle CLI', },
      { '<leader>ad', function() require('sidekick.cli').close() end, desc = 'Detach a CLI Session', },
      { '<leader>ap', function() require('sidekick.cli').prompt() end, desc = 'Sidekick Select Prompt', mode = { 'n', 'x' }, },
      { '<leader>at', function()
          local msg = vim.fn.mode():sub(1, 1) == 'n' and '{file}' or '{this}'
          require('sidekick.cli').send({ name = 'copilot', msg = msg })
        end, mode = { 'n', 'x' }, desc = 'Send This (file/selection)',
      },
      { '<C-.>', mode = { 'n', 't', 'i', 'x' }, function() require('sidekick.cli').toggle('copilot') end, },
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
    'R-nvim/R.nvim',
    enabled = false,
    init = function()
      local debug_r = function()
        local word = vim.fn.expand('<cword>')
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        -- copy the <cword> to a new line below the current line
        vim.api.nvim_buf_set_lines(0, row, row, true, { word })
        -- move cursor to the new line
        vim.api.nvim_win_set_cursor(0, { row + 1, 0 })
        -- execute <Plug>RInsertLineOutput from normal mode
        vim.api.nvim_feedkeys(vim.keycode('<Plug>RInsertLineOutput'), 'n', false)
        -- delete the line with the word
        vim.api.nvim_buf_set_lines(0, row, row + 1, true, {})
        -- move cursor back to original position
        vim.api.nvim_win_set_cursor(0, { row, col })
      end
      vim.keymap.set('n', '<leader>ur', debug_r, { desc = 'Debug R' })

      Snacks.util.set_hl({
        Inactive = { fg = '#aaaaaa' },
        Starting = { fg = '#757755' },
        ServerReady = { fg = '#117711' },
        TCPStart = { fg = '#ff8833' },
        TCPReady = { fg = '#3388ff' },
        RStarting = { fg = '#ff8833' },
        Ready = { fg = '#3388ff' },
      }, { prefix = 'RStatus', default = true })

      local rstt = {
        { '-', 'RStatusInactive' }, -- 1: ftplugin/* sourced, but nclientserver not started yet.
        { 'S', 'RStatusStarting' }, -- 2: nclientserver started, but not ready yet.
        { 'S', 'RStatusServerReady' }, -- 3: nclientserver is ready.
        { 'S', 'RStatusTCPStart' }, -- 4: nclientserver started the TCP server
        { 'S', 'RStatusTCPReady' }, -- 5: TCP server is ready
        { 'R', 'RStatusRStarting' }, -- 6: R started, but nvimcom was not loaded yet.
        { '󰟔 ', 'RStatusReady' }, -- 7: nvimcom is loaded.
      }

      _G.Rstatus = {
        function() return rstt[vim.g.R_Nvim_status][1] end,
        color = function() return rstt[vim.g.R_Nvim_status][2] end,
        cond = function() return vim.tbl_contains({ 'r', 'rmd', 'quarto' }, vim.bo.filetype) end,
      }

      require('r').setup({
        R_args = { '--quiet', '--no-save' },
        -- user_maps_only = true,
        -- quarto_chunk_hl = { highlight = false },
        Rout_more_colors = true,
        hook = {
          after_R_start = function() vim.notify('R started!') end,
          -- after_ob_open = function() vim.notify('Object Browser') end,
        },
      })
    end,
    keys = {
      -- nnoremap <leader>dR <Cmd>=require('r.config').get_config()<CR>
    },
  },
  {
    'hat0uma/csvview.nvim',
    ---@module "csvview"
    ---@type CsvView.Options
    opts = {
      parser = { comments = { '#', '//' } },
      keymaps = {
        -- FIXME: conflicts with treesitter function
        textobject_field_inner = { 'iF', mode = { 'o', 'x' } },
        textobject_field_outer = { 'aF', mode = { 'o', 'x' } },
        -- Excel-like navigation:
        -- Use <Tab> and <S-Tab> to move horizontally between fields.
        -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
        -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
        jump_next_field_end = { '<Tab>', mode = { 'n', 'v' } },
        jump_prev_field_end = { '<S-Tab>', mode = { 'n', 'v' } },
        jump_next_row = { '<Enter>', mode = { 'n', 'v' } },
        jump_prev_row = { '<S-Enter>', mode = { 'n', 'v' } },
      },
    },
    toggles = {
      ['<leader>cv'] = {
        name = 'csvView',
        get = function() require('csvview').is_enabled(0) end,
        set = function() require('csvview').toggle() end,
      },
    },
  },
}
