print('op')
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
if vim.fn.argc(-1) == 0 then
  vim.opt.laststatus = 0
end

-- if vim.fn.has('nvim-0.12') == 1 then
--   require('vim._extui').enable({
--     msg = {
--       pos = 'box',
--       box = { timeout = 2000 },
--     },
--   })
-- end
