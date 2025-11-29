vim.o.cmdheight = 0
vim.o.pumblend = 0
vim.o.pumborder = 'rounded'
vim.o.pumheight = 10
vim.o.winborder = 'rounded'
require('vim._extui').enable({})

-- FIXME: fails when installing new plugin before startup
local init = function()
    local confdir = vim.fs.joinpath(nv.root, 'config')
    local files = vim.fn.globpath(confdir, '*.lua', false, true)
    local iter = vim.iter(files)
    iter
      :filter(function(mod)
        return not vim.endswith(mod, 'init.lua')
      end)
      :map(nv.fn.modname)
      :each(nv.import)
  end

vim.api.nvim_create_autocmd('VimEnter', { callback = init })

return {}
