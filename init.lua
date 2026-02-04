--- init.lua

-- require('jit.p').start('ri1', '/tmp/prof') -- start luajit profiling

--- 1. source vimrc
---  - relies on autoload/plug.vim to override vim-plug calls
---  - enables `vim.loader` and `vim.pack.add`s base plugins
vim.cmd([[ runtime vimrc ]])

--- 2. snack attack!
--- - exposes global debug functions
-- FIXME: this will fail if snacks.nvim is not installed)
vim.opt.rtp:prepend(vim.g['plug#home'] .. '/snacks.nvim')
require('snacks') -- XXX: _G.Snacks
_G.dd = Snacks.debug.inspect
_G.bt = Snacks.debug.backtrace
_G.p = Snacks.debug.profile

-- 2.5 optional profiling
if vim.env.PROF then
  Snacks.profiler.startup({
    startup = { event = 'UIEnter' },
  })
end

--- 3. expose global config table
--- - sets up ui2 (`_extui`)
--- - lazily loads utility modules
_G.nv = require('nvim')

--- 4. import plug module convert plugins table to specs
local plugins = require('plugins')
local specs = vim.iter(plugins):map(nv.plug):totable()

--- 5. custom loader to `packadd` and run setup function
---@param plug_data {spec: vim.pack.Spec, path: string}
local function _load(plug_data)
  vim.cmd.packadd({ plug_data.spec.name, bang = true })
  return vim.tbl_get(plug_data.spec, 'data', 'setup')()
end

--- 6. `packadd` plugins with custom loader for setup
if vim.v.vim_did_enter == 0 then
  vim.pack.add(specs, { load = _load })
end

-- require('jit.p').stop()

-- vim: fdl=0 fdm=expr
