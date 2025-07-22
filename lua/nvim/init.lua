vim.loader.enable()

vim.opt.winborder = 'rounded'
vim.opt.cmdheight = 0
require('vim._extui').enable({})
require('nvim.plugins')

_G.icons = require('nvim.icons')

local settings = function()
  require('nvim.autocmds')
  require('nvim.diagnostic')
end

-- lazy-load settings if opening nvim without arguments
local lazy = vim.fn.argc(-1) == 0
if not lazy then
  settings()
end

local init = function()
  if lazy then
    settings()
  end
  vim.cmd([[ aunmenu PopUp | autocmd! nvim.popupmenu ]])
  vim.opt.clipboard = vim.env.SSH_TTY and '' or 'unnamedplus'
  vim.opt.jumpoptions = 'view,stack'
  vim.opt.mousescroll = 'hor:0'
  vim.opt.pumblend = 0
  vim.opt.smoothscroll = true
  -- require('munchies')
  -- make icons globally available
end

if vim.v.vim_did_enter == 1 then
  init()
else
  ---@diagnostic disable-next-line: param-type-mismatch
  vim.api.nvim_create_autocmd('VimEnter', {
    group = vim.api.nvim_create_augroup('init.lua', { clear = true }),
    once = true,
    callback = init,
  })
end

-- TODO:
-- start an instance of nvim in
-- the background without a ui attavched
-- on startup
-- attach to ui

-- neovim as an http server
-- attach to instance
-- view the buffers (logfiles)

-- todo section of redadme
-- nvim lua keymap to check current dir and parent dirts for a readme.md
