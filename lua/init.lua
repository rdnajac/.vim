vim.loader.enable()

local function settings()
  vim.opt.cmdheight = 0
  vim.opt.backupdir:remove('.')
  -- vim.opt.laststatus = 3
  vim.opt.winborder = 'rounded'
  require('nvim.autocmds')
  require('nvim.diagnostic')
  require('nvim.lsp')
end

local lazy = vim.fn.argc(-1) == 0
if not lazy then
  settings()
end

require('vim._extui').enable({})
require('nvim.plugins')

local function init()
  if lazy then
    settings()
  end
  vim.cmd([[ aunmenu PopUp | autocmd! nvim.popupmenu ]])
  vim.opt.clipboard = vim.env.SSH_TTY and '' or 'unnamedplus'
  vim.opt.foldexpr = 'v:lua.require("nvim.treesitter.fold").expr()'
  vim.opt.jumpoptions = 'view,stack'
  vim.opt.mousescroll = 'hor:0'
  vim.opt.pumblend = 0
  vim.opt.smoothscroll = true
  require('munchies')
end

if vim.v.vim_did_enter == 1 then
  init()
else
  vim.api.nvim_create_autocmd('VimEnter', {
    once = true,
    callback = init,
  })
end
