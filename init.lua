--- init.lua
local t_1 = vim.uv.hrtime()

--- optional LuaJIT profiling
--- `https://luajit.org/ext_profiler.html`
-- require('jit.p').start('ri1', '/tmp/prof')

--- overrides `loadfile()` and default nvim package loader
--- `https://github.com/neovim/neovim/discussions/36905`
vim.loader.enable()

--- `autoload/plug.vim` overrides vim-plug
--- `plug#end()` will `vim.pack.add` vim plugins
vim.cmd.source('vimrc')

_G.dd = function(...)
  local len = select('#', ...) ---@type number
  local obj = { ... } ---@type unknown[]
  local trace = require('nvim.util.debug').trace()
  local content = len == 1 and obj[1] or len > 0 and obj or ''
  local function p() vim.print(trace, content) end
  return vim.in_fast_event() and vim.schedule(p) or p()
end

if vim.env.PROF then
  vim.opt.rtp:append(vim.fn.stdpath('data') .. '/site/pack/core/opt/snacks.nvim')
  require('snacks.profiler').startup({ startup = { event = 'UIEnter' } })
end

_G.nv = require('nvim')
require('plug')

local specs = vim
  -- use tbl_keys to force a list and allow flatten
  .iter(vim.tbl_keys(nv))
  :map(function(v)
    local m = nv[v]
    -- stylua: ignore
    if vim.is_callable(m.after) then vim.schedule(m.after) end
    return type(m.specs) == 'table' and m.specs or nil
  end)
  :flatten()
  :map(Plug --[[@as fun(t: table): vim.pack.Spec?]])
  :totable()

vim.pack.add(specs, {
  load = function(plug_data)
    local spec = plug_data.spec ---@type vim.pack.Spec
    vim.cmd.packadd({ spec.name, bang = vim.v.vim_did_enter == 0 })
    -- local data = spec.data
    local init = vim.tbl_get(spec, 'data', 'init')
    if vim.is_callable(init) then
      init()
    end
    local map_keys = vim.tbl_get(spec, 'data', 'map_keys')
    if vim.is_callable(map_keys) then
      vim.schedule(map_keys)
    end
  end,
})

local elapsed = (vim.uv.hrtime() - t_1) / 1e6
vim.schedule(function() print('init.lua in ' .. elapsed .. 'ms') end)
-- require('jit.p').stop()
