--- init.lua
vim.cmd([[colorscheme tokyonight]])
vim.cmd([[source ~/.vim/vimrc]])

vim.o.cmdheight = 0
require('vim._core.ui2').enable({
  msg = { target = 'msg' },
})

_G.dd = function(...) Snacks.debug.inspect(...) end
_G.bt = function() Snacks.debug.backtrace() end

Plug(vim.list_extend({
  {
    'folke/snacks.nvim',
    opts = {
      explorer = { replace_netrw = true, trash = true },
      image = { enabled = true },
      indent = { indent = { only_current = false, only_scope = true } },
      input = { enabled = true },
      quickfile = { enabled = true },
      picker = require('munchies').picker,
      scope = { enabled = true },
      -- scroll = { enabled = true },
      words = { enabled = true },
    },
  },
}, require('nvim.plugins')))

require('mason').setup()

_G.nv = require('nvim')

vim.schedule(function()
  vim.o.statusline = [[%{%v:lua.nv.ui.status.line()%}]]
  vim.o.winbar = [[%{%v:lua.nv.ui.winbar()%}]]
  Snacks.config.style('lazygit', { height = 0, width = 0 })
end)
