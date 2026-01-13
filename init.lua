vim.loader.enable()

if vim.env.PROF then
  require('folke.snacks.profiler')
end

_G.dd = function(...) return Snacks and Snacks.debug.inspect(...) or vim.print(...) end
_G.bt = function(...) return Snacks and Snacks.debug.backtrace(...) or dd() end
_G.pp = function(...) return Snacks and Snacks.debug.profile(...) or nv.debug.profile(...) end

vim.o.cmdheight = 0
vim.o.winborder = 'rounded'
require('vim._extui').enable({})

vim.cmd([[runtime vimrc]])

require('folke.snacks')
require('folke.tokyonight')

_G.nv = require('nvim')
_G.Plug = require('plug')

-- plug begin
vim.iter(nv.specs):each(Plug) --[[@as function]]
-- plug end
vim.pack.add(Plug.specs(), { load = Plug.load })

-- TODO: encapsulate
vim.schedule(function()
  require('which-key').add(Plug.keys())
  -- nv.keymaps.register(Plug.keys())

  local toggles = vim.tbl_extend('error', Plug.toggles(), require('folke.snacks.toggles'))
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
