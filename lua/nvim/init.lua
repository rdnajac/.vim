vim.loader.enable()

vim.opt.winborder = 'rounded'
vim.opt.cmdheight = 0
vim.opt.backupdir:remove('.')

require('vim._extui').enable({})

local settings = function()
  require('nvim.autocmds')
  require('nvim.diagnostic')
  require('nvim.lsp')
end

local lazy = vim.fn.argc(-1) == 0
if not lazy then
  settings()
end

require('nvim.plugins')

local init = function()
  if lazy then
    settings()
  end
  vim.cmd([[ aunmenu PopUp | autocmd! nvim.popupmenu ]])
  vim.opt.clipboard = vim.env.SSH_TTY and '' or 'unnamedplus'
  vim.opt.foldexpr = 'v:lua.require("nvim.plugin.treesitter.fold").expr()'
  vim.opt.jumpoptions = 'view,stack'
  vim.opt.mousescroll = 'hor:0'
  vim.opt.pumblend = 0
  vim.opt.smoothscroll = true
  require('munchies')
  -- vim.opt.winborder = 'rounded'
end

if vim.v.vim_did_enter == 1 then
  init()
else
  lazyload('VimEnter', init)
end
