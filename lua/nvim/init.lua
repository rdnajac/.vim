vim.loader.enable() -- XXX: experimental!

vim.g.lazypath = vim.fn.stdpath('data') .. '/lazy'
local lazynvim = vim.g.lazypath .. '/lazy.nvim'

if not vim.uv.fs_stat(lazynvim) then
  load(vim.fn.system('curl -s https://raw.githubusercontent.com/folke/lazy.nvim/main/bootstrap.lua'))()
else
  vim.opt.rtp:prepend(lazynvim)
end

vim.opt.winborder = 'rounded'
vim.opt.laststatus = 3
vim.opt.cmdheight = 0

require('lazy.bootstrap')

require('vim._extui').enable({}) -- XXX: experimental!

-- TODO: move this to a proper plugin
require('nvim.ui.chromatophore') -- XXX: experimental!

LazyVim.on_very_lazy(function()
  vim.opt.clipboard = vim.env.SSH_TTY and '' or 'unnamedplus'
  -- vim.opt.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"
  vim.opt.foldexpr = 'v:lua.require("nvim.treesitter.fold").expr()'
  vim.opt.jumpoptions = 'view,stack'
  vim.opt.mousescroll = 'hor:0'
  vim.opt.pumblend = 0
  vim.opt.smoothscroll = true

  vim.cmd([[
  command! LazyHealth Lazy! load all | checkhealth

  aunmenu PopUp
  autocmd! nvim.popupmenu
  ]])
end)
