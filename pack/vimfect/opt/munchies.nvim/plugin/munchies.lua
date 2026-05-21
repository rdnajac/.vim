if vim.g.loaded_munchies ~= nil then
  return
end
vim.g.loaded_munchies = 1

require('snacks').setup({
  -- dashboard = { enabled = true },
  explorer = { enabled = true },
  image = { enabled = true },
  indent = { enabled = true }, -- TODO: native intent guides
  input = { enabled = true },
  -- quickfile = { enabled = true },
  picker = require('munchies').picker,
  scope = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = require('munchies').statuscolumn,
  words = { enabled = true },
})

-- vim.schedule(function() Snacks.config.style('lazygit', { height = 0, width = 0 }) end)
-- vim.cmd([[ hi! SnacksDashboardFile guifg=#2AC3DE gui=bold ]])
