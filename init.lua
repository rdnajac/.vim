--- init.lua
vim.loader.enable()
vim.o.undofile = true
vim.o.backup = true
vim.o.backupext = '.bak'
vim.o.backupdir = vim.fn.stdpath('state') .. '/backup//'
vim.opt.backupskip:append(vim.env.HOME .. '/.cache/*')

vim.api.nvim_create_user_command('Restart', function()
  local sesh = vim.fn.stdpath('state') .. '/Session.vim'
  vim.cmd(([[mksession! %s | confirm restart source %s]]):format(sesh, sesh))
end, { desc = 'Restart Neovim' })

if vim.env.PROF then
  vim.opt.rtp:append(vim.fn.stdpath('data') .. '/site/pack/core/opt/snacks.nvim')
  require('snacks.profiler').startup({ startup = { event = 'UIEnter' } })
end

vim.cmd([[ source ~/.vim/vimrc ]])

require('snacks').setup({
  -- bigfile = { enabled = true },
  -- dashboard = require('munchies.dashboard'),
  explorer = { replace_netrw = false },
  image = { enabled = true },
  indent = { indent = { only_current = false, only_scope = true } },
  input = { enabled = true },
  -- notifier = require('munchies.notifier'),
  quickfile = { enabled = true },
  picker = require('munchies.picker'),
  -- terminal = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = true },
  -- statuscolumn = require('munchies.statuscolumn'),
  styles = { lazygit = { height = 0, width = 0 } },
  toggle = { which_key = false },
  words = { enabled = true },
})

_G.dd = Snacks.debug.inspect
_G.bt = Snacks.debug.backtrace
_G.p = Snacks.debug.profile

require('nvim')
