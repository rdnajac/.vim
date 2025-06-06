print('op')
vim.opt.backup = false
vim.opt.backupdir = vim.fn.stdpath('state') .. '/backup//'
vim.opt.clipboard = vim.env.SSH_TTY and '' or 'unnamedplus'
vim.opt.foldexpr = 'v:lua.LazyVim.ui.foldexpr()'
vim.opt.foldlevel = 99
vim.opt.foldmethod = 'expr'
vim.opt.foldtext = ''
-- vim.opt.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"
vim.opt.laststatus = 0
vim.opt.mousescroll = 'hor:0'
vim.opt.pumblend = 0
vim.opt.signcolumn = 'yes'
vim.opt.smoothscroll = true
vim.opt.winborder = 'rounded'

if vim.fn.has('nvim-0.12') == 1 then
  vim.opt.cmdheight = 0
  require('vim._extui').enable({
    msg = {
      pos = 'box',
      box = { timeout = 2000 },
    },
  })
end

