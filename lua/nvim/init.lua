vim.loader.enable()

vim.o.cmdheight = 0
vim.o.pumblend = 0
vim.o.winborder = 'rounded'
require('vim._extui').enable({})

require('munchies')
require('nvim.autocmds')
require('nvim.colorscheme')

local settings = function()
  vim.cmd([[ aunmenu PopUp | autocmd! nvim.popupmenu ]])
  vim.o.clipboard = vim.env.SSH_TTY and '' or 'unnamedplus'
  vim.o.jumpoptions = 'view,stack'
  vim.o.mousescroll = 'hor:0'
  vim.o.smoothscroll = true
end

if vim.v.vim_did_enter == 1 then
  settings()
else
  ---@diagnostic disable-next-line: param-type-mismatch
  vim.api.nvim_create_autocmd('VimEnter', {
    group = vim.api.nvim_create_augroup('init.lua', { clear = true }),
    once = true,
    callback = settings,
  })
end

-- TODO:
-- start an instance of nvim in the background without a ui attached
-- on startup, attach to ui, then try out
-- neovim as an http server attach to instance view the buffers (logfiles)

_G.nvim = require('nvim.plugins')
