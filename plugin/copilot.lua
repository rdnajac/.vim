local cmp = vim.lsp.inline_completion

cmp.enable()

---
vim.keymap.set('i', '<C-J>', function()
  if not cmp.get() then
    return '<C-J>'
  end
end, { expr = true, desc = 'Accept the current inline completion' })
