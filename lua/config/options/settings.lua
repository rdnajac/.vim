vim.opt.backup = false
vim.opt.backupdir = vim.fn.stdpath('state') .. '/backup//'
vim.opt.clipboard = vim.env.SSH_TTY and '' or 'unnamedplus'
vim.opt.cmdheight = 0
vim.opt.foldexpr = 'v:lua.LazyVim.ui.foldexpr()'
vim.opt.foldlevel = 99
vim.opt.foldmethod = 'expr'
vim.opt.foldtext = ''
-- vim.opt.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"
vim.opt.mousescroll = 'hor:0'
vim.opt.pumblend = 0
vim.opt.signcolumn = 'yes'
vim.opt.smoothscroll = true
vim.opt.winborder = 'rounded'

-- HACK: don't show lualine on dashboard
-- PERF: does checking ft affect performance?
if vim.fn.argc(-1) == 0 and vim.bo.filetype == 'snacks_dashboard' then
-- if vim.fn.argc(-1) == 0 then
  vim.opt.laststatus = 0
end
