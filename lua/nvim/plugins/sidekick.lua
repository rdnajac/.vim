return {
  'folke/sidekick.nvim',
  --- @type sidekick.Config
  opts = {
    cli = { mux = { backend = 'tmux', enabled = false } },
  },
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
  status = function()
    local status = require('sidekick.status').get()
    return status and nv.icons.copilot[status.kind][1] or nv.icons.copilot.Inactive[1]
  end,
}
