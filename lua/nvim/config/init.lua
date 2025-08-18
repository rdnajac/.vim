-- automagically load plugin modules in this directory
-- vim.defer_fn(function()
--   require('util.meta').module()
-- end, 0)
require'nvim.config.autocmds'
require'nvim.config.commands'
require'nvim.config.diagnostic'
require'nvim.config.keymaps'
require'nvim.config.munchies'
