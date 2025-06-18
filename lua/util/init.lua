vim.cmd([[
  command! CD lua require('util.cd').prompt()
  command! SmartCD lua require('util.cd').smart()
  command! InstallTools lua require('util.installer').mason_install()
  command! -bang Quit lua require('util.quit').func('<bang>')
]])

local select = require('util.select')
-- stylua: ignore start
vim.keymap.set('n', '<C-Space>', function() select.start() end, { desc = 'Start selection'})
vim.keymap.set('x', '<C-Space>', function() select.increment() end, { desc = 'Increment selection' })
vim.keymap.set('x', '<BS>', function() select.decrement() end, { desc = 'Decrement selection' })

vim.keymap.set('v', '<C-r>', function() require('util.replace').selection() end, { desc = 'Replace' })
-- stylua: ignore end

local wk = require('which-key')
-- stylua: ignore
wk.add({
  { 'gl', function() require('util.togo').lazy() end, desc = 'Goto LazyVim module' },
  { 'gb', function() require('util.togo').github() end, desc = 'Open GitHub Repo in browser' },
})

