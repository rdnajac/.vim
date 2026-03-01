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
vim
  .iter(nv)
  :map(function(_, v)
    if vim.is_callable(v.after) then
      vim.schedule(v.after)
    end
    return type(v.specs) == 'table' and v.specs or nil
  end)
  :map(function(specs)
    return vim
      .iter(vim.islist(specs) and specs or { specs })
      :map(function(spec) return type(spec) == 'table' and spec or { spec } end)
      :filter(function(spec) return spec.enabled ~= false end)
      :map(function(self)
        local name = self[1]:match('[^/]+$')
        return {
          src = self.src or ('https://github.com/%s.git'):format(self[1]),
          -- version = self.version or self.branch or nil,
          name = name,
          data = self.data or {
            build = self.build,
            init = self.init,
            -- TODO: move setup params to data and register keys/toggles in load
            setup = function()
              local opts = vim.is_callable(self.opts) and self.opts() or self.opts
              if type(opts) == 'table' then
                local modname = name:gsub('%.nvim$', '')
                require(modname).setup(opts)
              elseif vim.is_callable(self.config) then
                self.config()
              end
              vim.schedule(function()
                local _keys = require('nvim.keys')
                if self.keys then
                  _keys.map(self.keys)
                end
                if self.toggles then
                  for key, v in pairs(self.toggles) do
                    _keys.map_snacks_toggle(key, v)
                  end
                end
              end)
            end,
          },
        }
      end)
      :totable()
  end)
  :each(function(speclist)
    vim.pack.add(speclist, {
      load = function(plug_data) ---@param plug_data { spec: vim.pack.Spec, path: string }
        local maybe = function(key) ---@param key string
          local fn = vim.tbl_get(plug_data.spec, 'data', key)
          return vim.is_callable(fn) and fn() or nil
        end
        maybe('init') -- run init for vim plugins or `package.preload` hijinks
        vim.cmd.packadd({ plug_data.spec.name, bang = vim.v.vim_did_enter == 0 })
        maybe('setup') -- run setup for neovim plugins with `opts` tables
      end,
    })
  end)

local elapsed = (vim.uv.hrtime() - t_1) / 1e6
vim.schedule(function() print('init.lua in ' .. elapsed .. 'ms') end)
-- require('jit.p').stop()
