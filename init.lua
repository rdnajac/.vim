--- init.lua
---
--- 0. enable `vim.loader` to override `require`
--- https://github.com/neovim/neovim/discussions/36905
vim.loader.enable()

--- optional LuaJIT profiling
--- https://luajit.org/ext_profiler.html
-- require('jit.p').start('ri1', '/tmp/prof')

--- 1. source vimrc and set settings
---  - autoload/plug.vim overrides vim-plug calls
---  - enables `vim.loader`
---  `vim.pack.add`s vim plugins
vim.cmd([[ runtime vimrc ]])

-- XXX: experimental!
vim.o.cmdheight = 0
-- BUG: ui2 error on declining to install after vim.pack.add
-- require('vim._core.ui2').enable({})
require('vim._core.ui2').enable({})

--- 2. snack attack!
local snackspath = vim.g['plug#home'] .. '/snacks.nvim'
if vim.uv.fs_stat(snackspath) then
  vim.opt.rtp:prepend(snackspath)
  require('snacks') -- XXX: exposes _G.Snacks
  -- assert(Snacks)
  _G.dd = Snacks.debug.inspect
  _G.bt = Snacks.debug.backtrace
  _G.p = Snacks.debug.profile
  -- 2.5 optional profiling with Snacks
  if vim.env.PROF then
    Snacks.profiler.startup({
      startup = { event = 'UIEnter' },
    })
  end
end

--- 3. the rest of the owl
_G.nv = require('nvim')

local _plugins = require('nvim.plugins')

vim.iter(nv):each(function(k, v)
  print('loading', k)
  if vim.is_callable(v.after) then
    vim.schedule(v.after) -- run afeter startup
  end
  vim.list_extend(_plugins, v.specs or {})
end)

-- PERF: filter plugins before converting to `vim.pack.Spec`
local plugins = vim.tbl_filter(function(t)
  return t.enabled ~= false
  -- return t.enabled == true end,
end, _plugins)

--- 4. import plug module convert plugins table to specs
local specs = vim.iter(plugins):map(nv.plug):totable()

--- 5. custom loader to `packadd` and run setup function
---@param plug_data {spec: vim.pack.Spec, path: string}
local function _load(plug_data)
  --- call a function in plugin's data table if callable
  local function maybe(key)
    local fn = vim.tbl_get(plug_data.spec, 'data', key)
    if vim.is_callable(fn) then
      fn()
    end
  end

  maybe('init') -- run init for vim plugins or `package` hijinks
  vim.cmd.packadd({ plug_data.spec.name, bang = true })
  maybe('setup') -- run setup for neovim plugins with `opts` tables
end

--- 6. `packadd` plugins with custom loader for setup
if vim.v.vim_did_enter == 0 then
  vim.pack.add(specs, { load = _load })
end

vim.schedule(function()
  -- TODO: figure out who sets this var
  vim.env.PACKDIR = vim.g.PACKDIR
  vim.o.winbar = [[%{%v:lua.nv.winbar()%}]]
end)

-- require('jit.p').stop()
