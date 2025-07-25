vim.loader.enable()

vim.o.cmdheight = 0
vim.o.pumblend = 0
vim.o.winborder = 'rounded'
require('vim._extui').enable({})

require('munchies')
