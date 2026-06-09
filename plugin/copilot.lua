local lsp = vim.lsp

lsp.inline_completion.enable()
lsp.enable('copilot')
lsp.config('copilot', { root_dir = vim.fn.expand('~/GitHub') })

vim.keymap.set('i', '<C-J>', function()
  if not lsp.inline_completion.get() then
    return '<C-J>'
  end
end, { expr = true, desc = 'Accept the current inline completion' })
