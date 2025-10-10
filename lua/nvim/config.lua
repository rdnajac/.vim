_G.nv = _G.nv or require('nvim.util')

-- These need to be set before extui is enabled
vim.o.cmdheight = 0
vim.o.winborder = 'rounded'

require('vim._extui').enable({})

vim.schedule(function()
  nv.for_all_files('nvim', 'config', function(_, mod)
    if mod.setup then
      mod.setup()
    end
  end)
end)
