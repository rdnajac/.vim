local M = {}

Snacks.util.on_key('<Esc>', function() vim.cmd.nohlsearch() end)
Snacks.keymap.set({ 'n' }, 'K', vim.lsp.buf.hover, { lsp = {} })
Snacks.keymap.set({ 'n', 'x' }, '<M-CR>', Snacks.debug.run, { ft = 'lua' })

-- normal and terminal mode keymaps
vim
  .iter({
    ['<C-Bslash> '] = function() Snacks.terminal.focus() end,
    [']]'] = function() Snacks.words.jump(vim.v.count1) end,
    ['[['] = function() Snacks.words.jump(-vim.v.count1) end,
  })
  :each(function(lhs, rhs) vim.keymap.set({ 'n', 't' }, lhs, rhs) end)

return M
