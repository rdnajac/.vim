return {
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

    local aug = vim.api.nvim_create_augroup('HideInlineCompletion', {})

    local function has_inline()
      return vim.lsp and vim.lsp.inline_completion
    end

    vim.api.nvim_create_autocmd('User', {
      group = aug,
      pattern = 'BlinkCmpMenuOpen',
      callback = function()
        if has_inline() and vim.lsp.inline_completion.is_enabled() then
          vim.b.inline_completion_toggle = true
          -- vim.lsp.inline_completion.enable(false)
          pcall(vim.lsp.inline_completion.enable, false)
        end
      end,
    })

    vim.api.nvim_create_autocmd('User', {
      group = aug,
      pattern = 'BlinkCmpMenuClose',
      callback = function()
        if has_inline() and vim.b.inline_completion_toggle then
          -- vim.lsp.inline_completion.enable(true)
          pcall(vim.lsp.inline_completion.enable, true)
          vim.b.inline_completion_toggle = nil
        end
      end,
    })
  end,
  -- stylua: ignore
      keys = {
      -- nes is also useful in normal mode
      { mode = 'n', '<Tab>',
        function()
          --if not require('sidekick').nes_jump_or_apply() then return '<Tab>' end
         return require('sidekick').nes_jump_or_apply() or '<Tab>'
        end,
        expr = true,
        desc = "Goto/Apply Next Edit Suggestion",
      },
      { '<leader>a', '', desc = '+ai', mode = { 'n', 'v' } },
      { '<leader>aa', function() require('sidekick.cli').toggle('copilot') end, desc = 'Sidekick Toggle CLI' },
      { '<leader>ad', function() require('sidekick.cli').close() end, desc = 'Detach a CLI Session' },
      { '<leader>ap', function() require('sidekick.cli').prompt() end, mode = { 'n', 'x' }, desc = 'Sidekick Select Prompt'  },
      { '<leader>at', function() require('sidekick.cli').send({msg='{this}'}) end, mode = { 'n', 'x' }, desc = 'Send This' },
      { '<leader>af', function() require('sidekick.cli').send({msg='{file}'}) end,                      desc = 'Send File' },
      { '<leader>av', function() require('sidekick.cli').send({msg='{selection}'}) end, mode = { 'x' }, desc = 'Send Visual Selection' },
      { '<C-.>',      function() require('sidekick.cli').toggle('copilot') end,    mode = { 'n', 't', 'i', 'x' }, desc = 'Sidekick Toggle' },
    },
}
