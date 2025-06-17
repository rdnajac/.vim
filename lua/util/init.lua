vim.cmd([[
  command! CD lua require('util.cd').changedir()
  command! SmartCD lua require('util.cd').smart_cd()
  command! -bang Quit lua require("util.quit").func('<bang>')
  command! InstallTools lua require('util.installer').mason_install()
]])

local select = require('util.select')
-- stylua: ignore start
vim.keymap.set('n', '<C-Space>', function() select.start() end, { desc = 'Start selection'})
vim.keymap.set('x', '<Space>', function() select.increment() end, { desc = 'Increment selection' })
vim.keymap.set('x', '<BS>', function() select.decrement() end, { desc = 'Decrement selection' })
-- stylua: ignore end

