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
  -- local len = select('#', ...) ---@type number
  local obj = { ... } ---@type unknown[]
  local trace = require('nvim.util.debug').bt()
  if not vim.in_fast_event() then
    return vim.print(trace, obj)
  end
  vim.schedule(function() vim.print(trace, obj) end)
end

if vim.env.PROF then
  vim.opt.rtp:append(vim.fn.stdpath('data') .. '/site/pack/core/opt/snacks.nvim')
  require('snacks.profiler').startup({ startup = { event = 'UIEnter' } })
end

_G.nv = require('nvim')

local Plug = nv.plug

vim
  .iter(nv)
  :map(function(_, v)
    vim.schedule(v.after)
    return v.specs
  end)
  :map(function(specs)
    return vim
      .iter(vim.islist(specs) and specs or { specs })
      :filter(function(spec) return spec.enabled ~= false end)
      :map(function(spec) return Plug.spec(spec) end)
      :map(function(self)
        return {
          src = self.src or ('https://github.com/%s.git'):format(self[1]),
          -- version = self.version or self.branch or nil,
          name = self.name or self[1]:match('[^/]+$'),
          data = self.data or {
            build = self.build,
            init = self.init,
            setup = function() return self:setup() end,
          },
        }
      end)
      :totable()
  end)
  :each(function(speclist) vim.pack.add(speclist, { load = Plug.load }) end)

local elapsed = (vim.uv.hrtime() - t_1) / 1e6
vim.schedule(function() print('init.lua in ' .. elapsed .. 'ms') end)
-- require('jit.p').stop()
