vim.pack.add({ 'https://github.com/folke/tokyonight.nvim.git' })
require('nvim.ui.tokyonight').init()
vim.schedule(function() vim.fn['chromatophore#setup']() end)
vim.cmd([[
  hi! SnacksDashboardFile guifg=#2AC3DE gui=bold
]])
