vim.loader.enable() -- XXX: experimental!

if vim.env.LAZY ~= nil then
  require('lazy.bootstrap')
else
  local gh = function(name)
    return 'https://github.com/' .. name
  end

  vim.pack.add({
    gh('echasnovski/mini.nvim'),
    gh('folke/snacks.nvim'),
    gh('folke/which-key.nvim'),
    gh('folke/tokyonight.nvim'),
    gh('monaqa/dial.nvim'),
    gh('stevearc/oil.nvim'),
    gh('Saghen/blink.cmp'),
    gh('mgalliou/blink-cmp-tmux'),
    gh('fang2hou/blink-copilot'),
    gh('moyiz/blink-emoji.nvim'),
    gh('bydlw98/blink-cmp-env'),
  })

  require('tokyonight').load(require('nvim.ui.tokyonight'))
  require('oil').setup(require('lazy.spec.oil').opts())
  require('oil').setup(require('lazy.spec.oil').opts())
  require('snacks').setup(require('lazy.spec.snacks').opts)
end

local M = {}

vim.opt.winborder = 'rounded'
vim.opt.laststatus = 3
vim.opt.cmdheight = 0

-- XXX: experimental!
require('vim._extui').enable({})

-- TODO: move this to a proper plugin
require('nvim.ui.chromatophore')

require('nvim.autocmds')
require('nvim.lazy')

-- LazyVim.on_very_lazy(function()
vim.schedule(function()
  vim.opt.clipboard = vim.env.SSH_TTY and '' or 'unnamedplus'
  -- vim.opt.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"
  vim.opt.foldexpr = 'v:lua.require("nvim.treesitter.fold").expr()'
  vim.opt.jumpoptions = 'view,stack'
  vim.opt.mousescroll = 'hor:0'
  vim.opt.pumblend = 0
  vim.opt.smoothscroll = true
  require('nvim.diagnostic')
  require('nvim.lsp')

  vim.cmd([[
  command! LazyHealth Lazy! load all | checkhealth

  aunmenu PopUp
  autocmd! nvim.popupmenu
  ]])
end)

return M
