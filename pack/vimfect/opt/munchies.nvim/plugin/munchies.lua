if vim.g.loaded_munchies then
  return
end
vim.g.loaded_munchies = 1

require('snacks').setup({
  -- bigfile = { enabled = true },
  -- dashboard = { enabled = true },
  explorer = { enabled = true },
  image = { enabled = true },
  -- TODO: native intent guides
  indent = { enabled = true },
  input = { enabled = true },
  quickfile = { enabled = true },
  picker = require('munchies').picker,
  scope = { enabled = true },
  scroll = { enabled = true },
  -- statuscolumn = { enabled = true },
  words = { enabled = true },
})

vim.schedule(function() Snacks.config.style('lazygit', { height = 0, width = 0 }) end)

vim.cmd([[ hi! SnacksDashboardFile guifg=#2AC3DE gui=bold ]])
