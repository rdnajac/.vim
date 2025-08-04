local M = { 'github/copilot.vim' }

M.config = function()
  vim.deprecate = function() end -- HACK: remove this once plugin is updated
  vim.g.copilot_workspace_folders = { '~/GitHub', '~/.local/share/chezmoi/' }
  -- vim.g.copilot_no_maps = true
  vim.g.copilot_no_tab_map = true
  vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false })

  local aug = vim.api.nvim_create_augroup('copilot', { clear = true })
  -- Block the normal Copilot suggestions if using blink integration
  -- vim.api.nvim_create_autocmd({ 'FileType', 'BufUnload' }, {
  --   group = 'github_copilot',
  --   callback = function(args)
  --     vim.fn['copilot#On' .. args.event]()
  --   end,
  -- })
  -- vim.fn['copilot#OnFileType']()

  ---@diagnostic disable-next-line: param-type-mismatch
  vim.api.nvim_create_autocmd('User', {
    pattern = 'BlinkCmpMenuOpen',
    group = aug,
    callback = function()
      vim.fn['copilot#Dismiss']()
      vim.b.copilot_suggestion_hidden = true
    end,
  })

  ---@diagnostic disable-next-line: param-type-mismatch
  vim.api.nvim_create_autocmd('User', {
    pattern = 'BlinkCmpMenuClose',
    group = aug,
    callback = function()
      vim.b.copilot_suggestion_hidden = false
    end,
  })

  -- vim.cmd([[
  --   augroup CopilotSuggestion
  --   autocmd!
  --   autocmd User BlinkCmpMenuOpen call copilot#Dismiss() | let b:copilot_suggestion_hidden = v:true
  --   autocmd User BlinkCmpMenuClose let b:copilot_suggestion_hidden = v:false
  --   augroup END
  -- ]])
end

-- Snacks.util.set_hl({ CopilotSuggestion = { bg = '#414868', fg = '#7aa2f7' } })

return M
