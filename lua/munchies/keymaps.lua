vim.keymap.set({ 'n', 't' }, '<c-\\>', function()
  Snacks.terminal.toggle()
end)
-- stylua: ignore start
local function map_pickers(key, path, desc, extra)
  local opts = vim.tbl_extend('force', { cwd = path, matcher = { frecency = true }, title = desc }, extra or {})
  vim.keymap.set('n', '<leader>f' .. key, function() Snacks.picker.files(opts) end, { desc = desc })
  vim.keymap.set('n', '<leader>s' .. key, function() Snacks.picker.grep(opts) end, { desc = desc })
end

map_pickers('c', vim.fn.stdpath('config'), 'Config Files')
map_pickers('.', os.getenv('HOME') .. '/.local/share/chezmoi', 'Dotfiles')
map_pickers('G', vim.fn.expand('~/GitHub/'), 'GitHub Repos')
map_pickers('v', vim.fn.expand('$VIMRUNTIME'), '$VIMRUNTIME')
map_pickers('V', vim.fn.expand('$VIM'), '$VIM')
map_pickers('p', vim.fn.expand('~/.vim/pack'), 'Plugins', { ignored = true })

vim.keymap.set('n', '<leader>fb', function() Snacks.picker.buffers() end, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>fB', function() Snacks.picker.buffers({ hidden = true, nofile = true }) end, { desc = 'Buffers (all)' })
vim.keymap.set('n', '<leader>sb', function() Snacks.picker.lines() end, { desc = 'Buffer Lines' })
vim.keymap.set('n', '<leader>sB', function() Snacks.picker.grep_buffers() end, { desc = 'Grep Open Buffers' })
vim.keymap.set('n', '<leader>uz', function() Snacks.zen() end, { desc = 'Zen Mode' })

vim.keymap.set('n', '<leader>ui', function() vim.show_pos() end, { desc = 'Inspect Pos' })
vim.keymap.set('n', '<leader>uI', function() vim.treesitter.inspect_tree(); vim.api.nvim_input('I') end, { desc = 'Inspect Tree' })

-- stylua: ignore end

vim.keymap.set({ 'i', 'n', 's' }, '<esc>', function()
  vim.cmd('noh')
  return '<Esc>'
end, { expr = true, desc = 'Escape and Clear hlsearch' })
