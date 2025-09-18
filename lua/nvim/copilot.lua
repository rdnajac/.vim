M = {}

M.specs = {
  'github/copilot.vim',
  -- 'fang2hou/blink-copilot',
  -- {
  'olimorris/codecompanion.nvim',
  --   dependencies = {
  'nvim-lua/plenary.nvim',
  --     'nvim-treesitter/nvim-treesitter',
  --   },
  --   opts = {},
  -- },
}

vim.g.copilot_no_tab_map = true

M.config = function()
  require('codecompanion').setup({})
  vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
    expr = true,
    replace_keycodes = false,
  })
end

M.after = function()
  -- TODO: add copilot toggle
  -- vim.schedule(function()
  vim.defer_fn(function()
    vim.cmd([[ delcommand PlenaryBustedDirectory | delcommand PlenaryBustedFile ]])
  end, 2000)
  require('nvim.util.module').on_module('blink.cmp', function()
    local aug = vim.api.nvim_create_augroup('BlinkCopilot', { clear = true })

    vim.api.nvim_create_autocmd('User', {
      pattern = 'BlinkCmpMenuOpen',
      group = aug,
      command = 'call copilot#Dismiss() | let b:copilot_enabled = v:false',
    })

    vim.api.nvim_create_autocmd('User', {
      pattern = 'BlinkCmpMenuClose',
      group = aug,
      command = 'let b:copilot_enabled = v:true',
    })
  end)
end

return M
