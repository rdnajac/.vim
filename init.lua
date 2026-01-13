vim.loader.enable()

if vim.env.PROF then
  require('folke.snacks.profiler')
end

vim.cmd([[runtime vimrc]])
vim.o.cmdheight = 0
vim.o.winborder = 'rounded'
require('vim._extui').enable({})

_G.nv = require('nvim')
_G.Plug = require('plug')

-- plug begin
vim.iter(nv.specs):each(Plug) --[[@as function]]

-- plug end
vim.pack.add(Plug.specs(), { load = Plug.load })
vim.schedule(function()
  require('which-key').add(Plug.keys())

  local toggles = vim.tbl_extend('force', Plug.toggles(), require('folke.snacks.toggles'))
  for key, v in pairs(toggles) do
    local type_ = type(v)
    if type_ == 'table' then
      Snacks.toggle.new(v):map(key)
    elseif type_ == 'string' then
      Snacks.toggle.option(v):map(key)
    elseif type_ == 'function' then
      v():map(key) -- preset toggles
    end
  end
end)
