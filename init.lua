--- init.lua
vim.cmd([[source ~/.vim/vimrc]])
vim.cmd([[colorscheme tokyonight]])

_G.dd = function(...) Snacks.debug.inspect(...) end
_G.bt = function() Snacks.debug.backtrace() end
require('snacks').setup({
    explorer = { enabled = true },
    image = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    quickfile = { enabled = true },
    picker = require('munchies').picker,
    -- picker = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    words = { enabled = true },
})

_G.nv = require('nvim')
Plug(require('blink.spec'))

vim.schedule(function() require('vim._core.ui2').enable({ msg = { target = 'msg' } }) end)
