vim.lsp.inline_completion.enable()

-- Cycle suggestions: Next
vim.keymap.set('i', '<M-n>', function()
  vim.lsp.inline_completion.select({ count = 1 })
end, { desc = 'Next inline completion' })

-- Cycle suggestions: Previous
vim.keymap.set('i', '<M-p>', function()
  vim.lsp.inline_completion.select({ count = -1 })
end, { desc = 'Previous inline completion' })
--
Snacks.toggle({
  name = 'Inline Completion',
  get = function()
    return vim.lsp.inline_completion.is_enabled()
  end,
  set = function(state)
    vim.lsp.inline_completion.enable(state)
  end,
}):map('<M-,>')

