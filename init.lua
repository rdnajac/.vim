--- init.lua

-- https://luajit.org/ext_profiler.html
-- require('jit.p').start('ri1', '/tmp/prof')

-- https://github.com/neovim/neovim/discussions/36905
vim.loader.enable()

--- 1. source vimrc
---  - autoload/plug.vim overrides vim-plug calls
---  - enables `vim.loader`
---  `vim.pack.add`s vim plugins
vim.cmd([[ runtime vimrc ]])

--- 2. snack attack!
--- global `Snacks` and debug functions
local snackspath = vim.g['plug#home'] .. '/snacks.nvim'
if vim.uv.fs_stat(snackspath) then
  vim.opt.rtp:prepend(snackspath)
  require('snacks') -- XXX: exposes _G.Snacks
  -- assert(Snacks)
  _G.dd = Snacks.debug.inspect
  _G.bt = Snacks.debug.backtrace
  _G.p = Snacks.debug.profile
  -- 2.5 optional profiling
  if vim.env.PROF then
    Snacks.profiler.startup({
      startup = { event = 'UIEnter' },
    })
  end
end

--- 3. the rs
--- - sets up ui2 (`_extui`)
--- - lazily loads utility modules
_G.nv = require('nvim')

--- 4. import plug module convert plugins table to specs
local plugins = require('plugins')
local specs = vim.iter(plugins):map(nv.plug):totable()

--- 5. custom loader to `packadd` and run setup function
---@param plug_data {spec: vim.pack.Spec, path: string}
local function _load(plug_data)
  -- helper to maybe call a function in plugin's data table
  local function maybe(fn)
    if vim.tbl_get(plug_data.spec, 'data', fn) and vim.is_callable(plug_data.spec.data[fn]) then
      plug_data.spec.data[fn]()
    end
  end
  maybe('init')
  vim.cmd.packadd({ plug_data.spec.name, bang = true })
  maybe('setup')
end

--- 6. `packadd` plugins with custom loader for setup
if vim.v.vim_did_enter == 0 then
  vim.pack.add(specs, { load = _load })
end

-- TODO: figure out who sets this var
vim.schedule(function() vim.env.PACKDIR = vim.g.PACKDIR end)

-- require('jit.p').stop()
