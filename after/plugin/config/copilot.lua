vim.deprecate = function() end -- HACK: remove this once plugin is updated
-- vim.g.copilot_no_maps = true
vim.g.copilot_workspace_folders = { '~/GitHub', '~/.local/share/chezmoi/' }

vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false,
})
vim.g.copilot_no_tab_map = true

-- Block the normal Copilot suggestions if using blink integration
-- vim.api.nvim_create_augroup('github_copilot', { clear = true })
-- vim.api.nvim_create_autocmd({ 'FileType', 'BufUnload' }, {
--   group = 'github_copilot',
--   callback = function(args)
--     vim.fn['copilot#On' .. args.event]()
--   end,
-- })
-- vim.fn['copilot#OnFileType']()

vim.api.nvim_create_autocmd('User', {
  pattern = 'BlinkCmpMenuOpen',
  callback = function()
    vim.fn['copilot#Dismiss']()
    vim.b.copilot_suggestion_hidden = true
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'BlinkCmpMenuClose',
  callback = function()
    vim.b.copilot_suggestion_hidden = false
  end,
})
