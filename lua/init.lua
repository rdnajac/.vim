vim.loader.enable()

vim.opt.backupdir:remove('.')
vim.opt.cmdheight = 0
-- vim.opt.laststatus = 3
require('vim._extui').enable({})
require('nvim.autocmds')
require('nvim.diagnostic')
require('nvim.lsp')
require('nvim.munchies')

if vim.env.LAZY ~= nil then
  require('lazy.bootstrap')
  return
end

local Plug = function(name)
  return 'https://github.com/' .. name
end

-- ~/.local/share/nvim/site/pack/core/opt/
vim.pack.add({
  -- libraries
  Plug('echasnovski/mini.nvim'),
  Plug('folke/snacks.nvim'),
  Plug('stevearc/oil.nvim'),
  -- ui
  Plug('folke/tokyonight.nvim'),
  Plug('folke/which-key.nvim'),
  -- editing
  Plug('Saghen/blink.cmp'),
  Plug('monaqa/dial.nvim'),
  -- lang
  Plug('mason-org/mason.nvim'),
  Plug('folke/lazydev.nvim'),
  {
    src = Plug('nvim-treesitter/nvim-treesitter'),
    version = 'main',
  },
  Plug('folke/ts-comments.nvim'),
})

local aug = vim.api.nvim_create_augroup('LazyLoad', { clear = true })
function _G.lazyload(fn)
  vim.api.nvim_create_autocmd('VimEnter', {
    group = aug,
    once = true,
    callback = fn,
  })
end

require('plugins.snacks').config()
require('plugins.oil').config()
require('plugins.mini').config()
require('plugins.which-key').config()
require('plugins.mason').config()
require('plugins.lazydev').config()
-- TODO: move spec to plugins?
require('nvim.colorscheme')
require('nvim.treesitter')

lazyload(function()
  vim.cmd([[ aunmenu PopUp | autocmd! nvim.popupmenu ]])
  vim.opt.clipboard = vim.env.SSH_TTY and '' or 'unnamedplus'
  -- vim.opt.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"
  vim.opt.foldexpr = 'v:lua.require("nvim.treesitter.fold").expr()'
  vim.opt.jumpoptions = 'view,stack'
  vim.opt.mousescroll = 'hor:0'
  vim.opt.pumblend = 0
  vim.opt.smoothscroll = true
  require('plugins.blink').config()
  require('plugins.dial').config()
  require('nvim.ui.chromatophore')
  require('nvim.keymaps')
end)
