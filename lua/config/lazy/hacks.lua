print('hacks')
vim.g.lazyvim_check_order = false

vim.opt.rtp:append(vim.fn.stdpath('data') .. '/lazy/LazyVim/')

local M = require('lazyvim.config')

require('lazyvim.config').setup(require('config.lazy.opts'))
M.setup()

-- _G.LazyVim = require('lazyvim.util')
M.init()
LazyVim.plugin.lazy_file()
