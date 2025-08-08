-- automagically load plugin modules in this directory
return ('meta.module')()
-- vim.defer_fn(function()
--   require('nvim.config.autocmds')
--   require('nvim.config.commands')
--   require('nvim.config.keymaps')
-- end, 0)
