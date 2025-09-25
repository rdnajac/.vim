-- vim.keymap.set('n', 'zS', vim.show_pos)
vim.keymap.set('n', '<leader>ui', vim.show_pos)

  -- no hlsearch on <Esc>
  -- vimscript: nnoremap <expr> <Esc> ':nohlsearch\<CR><Esc>'
  -- vim.keymap.set({ 'i', 'n', 's' }, '<Esc>', function()
  --   vim.cmd.nohlsearch()
  --   return '<Esc>'
  -- end, { expr = true, desc = 'Escape and Clear hlsearch' })

  -- stylua: ignore start
  Snacks.util.on_key('<Esc>', vim.cmd.nohlsearch)
