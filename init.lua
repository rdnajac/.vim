_G.t = { vim.uv.hrtime() }

vim.g.health = { style = 'float' }

_G.info = function(...)
  return vim.print(vim.inspect(...))
end

vim.loader.enable()

-- initializes vim.g.plugins
vim.cmd([[runtime vimrc]])

require('nvim')

require('nvim.util').lazyload(function()
  vim.fn['chromatophore#setup']()
  require('nvim.util.sourcecode')
end)

vim.schedule(function()
  nv.plug(nv.diagnostic)
end)
nv.plug(nv.blink)
nv.plug(nv.dial)
nv.plug(nv.lsp)
nv.plug(nv.r)
nv.plug(nv['render-markdown'])
nv.plug(nv.treesitter)

-- track('init])')
