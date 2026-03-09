return {
  {
    'folke/sidekick.nvim',
    -- enabled = false,
    opts = {},
    after = function()
      vim.lsp.enable('copilot')
      vim.lsp.inline_completion.enable()
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
    init = function()
      require('r').setup({
        R_args = { '--quiet', '--no-save' },
        -- user_maps_only = true,
        -- quarto_chunk_hl = { highlight = false },
        Rout_more_colors = true,
        hook = {
          -- after_R_start = function() vim.notify('R was launched') end,
          -- after_ob_open = function() vim.notify('Object Browser') end,
        },
      })
    end,
  },
}
