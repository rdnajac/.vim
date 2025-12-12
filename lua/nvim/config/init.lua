vim.o.cmdheight = 0
vim.o.pumblend = 0
vim.o.pumborder = 'rounded'
-- vim.o.pumheight = 10
vim.o.winborder = 'rounded'
require('vim._extui').enable({})

local init = function()
  vim.iter(nv.submodules()):each(nv.import)
end

vim.api.nvim_create_autocmd('VimEnter', { callback = init })
