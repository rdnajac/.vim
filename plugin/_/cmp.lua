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

---  vim.keymap.set('i', '<Tab>', function()
---   if not vim.lsp.inline_completion.get() then
---     return '<Tab>'
---   end
--- end, { expr = true, desc = 'Accept the current inline completion' })
-- vim.schedule(autocmds)
-- vim.lsp.enable('copilot')
vim.lsp.inline_completion.enable()
