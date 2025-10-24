-- vim.keymap.set('n', 'zS', vim.showpos)
vim.keymap.set('n', '<leader>ui', vim.show_pos)
vim.keymap.set('n', '<leader>uI', function()
  vim.treesitter.inspect_tree()
  vim.api.nvim_input('I')
end, { desc = 'Inspect Tree' })

vim.keymap.set('n', '<leader>xl', function()
  local success, err =
    pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = 'Location List' })

vim.keymap.set('n', '<leader>xq', function()
  local success, err =
    pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = 'Quickfix List' })

vim.keymap.set('n', 'yu', nv.debug.print, { desc = 'Debug print <cword>' })

-- stylua: ignore start
vim.keymap.set({'n','t'}, '<c-\\>', function() Snacks.terminal.toggle() end)
vim.keymap.set('v', '<leader>/', function() Snacks.picker.grep_word() end)
vim.keymap.set('n', '<leader>sW', 'viW<Cmd>lua Snacks.picker.grep_word()<CR>', { desc = 'Grep <cWORD>' })
-- stylua: ignore end

local shortcuts = {
  n = 'nvim/init',
  s = 'nvim/snacks',
  c = 'nvim/config',
  p = 'nvim/util/plug',
  P = 'nvim/plugins/init',
  m = 'nvim/plugins/mini',
  u = 'nvim/util/init',
  k = 'nvim/config/keymaps',
}

for key, mod in pairs(shortcuts) do
  vim.keymap.set('n', '<Bslash>' .. key, function()
    vim.fn['edit#luamod'](mod)
  end, { desc = 'Edit ' .. mod })
end

Snacks.util.on_key('<Esc>', function()
  vim.cmd.nohlsearch()
  if package.loaded['sidekick'] then
    require('sidekick').clear()
  end
end)

Snacks.util.on_key('<C-Space>', function()
  if package.loaded['sidekick'] then
    require('sidekick').clear()
  end
end)
