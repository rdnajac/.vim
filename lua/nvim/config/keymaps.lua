require('which-key').add(nv.snacks.keys())
-- vim.keymap.set('n', 'zS', vim.show_pos)
vim.keymap.set('n', '<leader>ui', vim.show_pos)
vim.keymap.set('n', '<leader>uI', function()
  vim.treesitter.inspect_tree()
  vim.api.nvim_input('I')
end, { desc = 'Inspect Tree' })

-- no hlsearch on <Esc>
-- vimscript: noremap <expr> <Esc> ':nohlsearch\<CR><Esc>'
-- vim.keymap.set({ 'i', 'n', 's' }, '<Esc>', function()
--   vim.cmd.nohlsearch()
--   return '<Esc>'
-- end, { expr = true, desc = 'Escape and Clear hlsearch' })
-- Snacks.util.on_key('<Esc>', vim.cmd.nohlsearch)
Snacks.util.on_key('<Esc>', function()
  vim.cmd.nohlsearch()
end)
