-- these require nvim nightly
vim.o.pumblend = 0
vim.o.pumborder = 'rounded'
vim.o.pumheight = 10

-- these must be set before extui is enabled
vim.o.cmdheight = 0
vim.o.winborder = 'rounded'
-- FIXME: doesn't play nice with a fresh vim.pack.add
require('vim._extui').enable({})

-- run all `setup` functions in `nvim/config/*.lua` after startup
vim.schedule(function()
  _G.nv = _G.nv or require('nvim.util')
  nv.config = vim.iter(nv.submodules('config')):fold({}, function(acc, submod)
    local mod = require(submod)
    if type(mod.setup) == 'function' then
      mod.setup()
    end
    acc[submod:match('[^/]+$')] = mod
    return acc
  end)
end)

Snacks.picker.scriptnames = function()
  require('nvim.snacks.picker.scriptnames')
end
