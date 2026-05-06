if vim.g.loaded_munchies then
  return
end
vim.g.loaded_munchies = 1

vim.schedule(function() Snacks.config.style('lazygit', { height = 0, width = 0 }) end)

vim.cmd([[ hi! SnacksDashboardFile guifg=#2AC3DE gui=bold ]])
