--- init.lua
local t_1 = vim.uv.hrtime()

vim.loader.enable() -- `https://github.com/neovim/neovim/discussions/36905`

--- `autoload/plug.vim` overrides vim-plug
--- `plug#end()` will `vim.pack.add` vim plugins
vim.cmd([[source vimrc]])
-- vim.cmd.source(vim.fn.stdpath('config') .. '/vimrc')
-- vim.cmd.source(vim.api.nvim_get_runtime_file('vimrc', false))

if vim.env.PROF then
  vim.opt.rtp:append(vim.fn.stdpath('data') .. '/site/pack/core/opt/snacks.nvim')
  require('snacks.profiler').startup({ startup = { event = 'UIEnter' } })
end

vim.o.cmdheight = 0 -- XXX: experimental!
-- vim.cmd([[ set cmdheight=0 ]])
-- BUG: ui2 error on declining to install after vim.pack.add
require('vim._core.ui2').enable({
  msg = { target = 'msg' },
})

_G.nv = require('nvim')

local keys = {} ---@type string[]
for k, v in pairs(nv) do
  vim.validate('submodule', v, 'table')
  vim.validate('specs', v.specs, vim.islist)
  -- vim.validate('after', v.after,  'function' , true)
  keys[#keys + 1] = k
  if v.after then
    vim.schedule(v.after)
  end
end

local plug = require('plug')
-- iterate over they keys instead of `M` to allow `flatten()`
---@type vim.pack.Spec[]
local speclist = vim
  .iter(keys)
  :map(function(k) return nv[k].specs end)
  :flatten()
  :filter(function(spec) return spec.enabled ~= false end)
  :map(plug.new)
  :map(function(plugin) return plugin:to_pack_spec() end)
  :totable()

-- :each(function(spec)
-- vim.pack.add(speclist, { load = plug.load, confirm = false })
vim.pack.add(vim.list_extend(vim.g.plugs or {}, speclist), {
  load = plug.load,
  confirm = false,
})

-- local msg = ('init.lua in %sms'):format((vim.uv.hrtime() - t_1) / 1e6)
local msg = ('_init.lua_: Loaded in **%s** ms'):format((vim.uv.hrtime() - t_1) / 1e6)
vim.schedule(function() print(msg) end)
