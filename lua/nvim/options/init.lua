vim.opt.backup = true
vim.opt.backupdir = vim.fn.stdpath('state') .. '/backup//'
vim.opt.clipboard = vim.env.SSH_TTY and '' or 'unnamedplus'
vim.opt.cmdheight = 0
-- vim.opt.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"
vim.opt.mousescroll = 'hor:0'
vim.opt.pumblend = 0
vim.opt.signcolumn = 'yes'
vim.opt.smoothscroll = true
vim.opt.winborder = 'rounded'
vim.opt.jumpoptions = 'view,stack'

-- HACK: don't show lualine on dashboard
if vim.fn.argc(-1) == 0 and vim.bo.filetype == 'snacks_dashboard' then
  vim.opt.laststatus = 0
end

require('nvim.options.diagnostic')
require('nvim.options.lsp')
require('nvim.options.x')
