local toggle_inline_completion = Snacks.toggle.new({
  name = 'Inline Completion',
  get = function() return vim.lsp.inline_completion.is_enabled() end,
  set = function(state) vim.lsp.inline_completion.enable(state) end,
})

toggle_inline_completion:map('<leader>ai')

-- local aug = vim.api.nvim_create_augroup('HideInlineCompletion', {})
-- vim.api.nvim_create_autocmd('User', {
--   group = aug,
--   pattern = 'BlinkCmpMenuOpen',
--   callback = function() toggle_inline_completion:toggle() end,
-- })
-- vim.api.nvim_create_autocmd('User', {
--   group = aug,
--   pattern = 'BlinkCmpMenuClose',
--   callback = function() toggle_inline_completion:toggle() end,
-- })

---  vim.keymap.set('i', '<Tab>', function()
---   if not vim.lsp.inline_completion.get() then
---     return '<Tab>'
---   end
--- end, { expr = true, desc = 'Accept the current inline completion' })
-- vim.schedule(autocmds)
-- vim.lsp.enable('copilot')
vim.lsp.inline_completion.enable()

-- NOTE: In GUI and supporting terminals, `<C-i>` can be mapped separately from `<Tab>`
-- ...except in tmux: `https://github.com/tmux/tmux/issues/2705`
-- vim.keymap.set('n', '<C-i>', '<Tab>', { desc = 'restore <C-i>' })
