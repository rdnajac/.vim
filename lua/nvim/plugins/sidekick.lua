local autocmds = function()
  local aug = vim.api.nvim_create_augroup('HideInlineCompletion', {})
  vim.api.nvim_create_autocmd('User', {
    group = aug,
    pattern = 'BlinkCmpMenuOpen',
    callback = function()
      if vim.lsp.inline_completion.is_enabled() then
        _G.inline_completion_toggle = true
        -- vim.lsp.inline_completion.enable(false)
        pcall(vim.lsp.inline_completion.enable, false)
      end
    end,
  })
  vim.api.nvim_create_autocmd('User', {
    group = aug,
    pattern = 'BlinkCmpMenuClose',
    callback = function()
      if _G.inline_completion_toggle then
        -- vim.lsp.inline_completion.enable(true)
        pcall(vim.lsp.inline_completion.enable, true)
        _G.inline_completion_toggle = nil
      end
    end,
  })
end
-- vim.schedule(autocmds)
-- vim.lsp.enable('copilot')
vim.lsp.inline_completion.enable()
return {
  'folke/sidekick.nvim',
  enabled = true,
  ---@type sidekick.Config
  opts = {
    cli = { win = { layout = 'float' } },
  },
  -- stylua: ignore
  keys = {
  { mode = 'n', expr = true, '<Tab>',
    function()
      return require('sidekick').nes_jump_or_apply() and '' or '<Tab>'
    end,
  },
  { '<leader>a', group = 'ai', mode = { 'n', 'v' } },
  { '<leader>aa', function() require('sidekick.cli').toggle('copilot') end, desc = 'Sidekick Toggle CLI' },
  { '<leader>aA', function() require('sidekick.cli').toggle() end, desc = 'Sidekick Toggle CLI' },
  { '<leader>ad', function() require('sidekick.cli').close() end, desc = 'Detach a CLI Session' },
  { '<leader>ap', function() require('sidekick.cli').prompt() end, desc = 'Sidekick Select Prompt', mode = { 'n', 'x' } },
  { '<leader>at', function()
      local msg = vim.fn.mode():sub(1, 1) == 'n' and '{file}' or '{this}'
      require('sidekick.cli').send({ name = 'copilot', msg = msg })
    end, mode = { 'n', 'x' }, desc = 'Send This (file/selection)',
  },
  { mode = { 'n', 't', 'i', 'x' }, '<C-.>',
    function()
      require('sidekick.cli').toggle('copilot')
    end,
  },
  },
  toggles = {
    ['<leader>uN'] = {
      name = 'Sidekick NES',
      get = function()
        return require('sidekick.nes').enabled
      end,
      set = function(state)
        require('sidekick.nes').enable(state)
      end,
    },
  },
}
