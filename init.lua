-- init.lua

--- optional LuaJIT profiling
--- https://luajit.org/ext_profiler.html
-- require('jit.p').start('ri1', '/tmp/prof')

--- overrides `loadfile()` and default nvim package loader
--- https://github.com/neovim/neovim/discussions/36905
vim.loader.enable()

--- 1. source vimrc
---   - `autoload/plug.vim` overrides vim-plug
---   - `plug#end()` will `vim.pack.add` vim plugins
vim.cmd([[ runtime vimrc ]])

-- XXX: experimental!
vim.o.cmdheight = 0
-- BUG: ui2 error on declining to install after vim.pack.add
require('vim._core.ui2').enable({
  msg = { target = 'msg' },
})

--- 2. snack attack!
require('snacks')
-- assert(Snacks)
_G.dd = Snacks.debug.inspect
_G.bt = Snacks.debug.backtrace
_G.p = Snacks.debug.profile

if vim.env.PROF then
  Snacks.profiler.startup({
    startup = { event = 'UIEnter' },
  })
end

Snacks.setup({
  bigfile = require('nvim.snacks.bigfile'),
  dashboard = require('nvim.snacks.dashboard'),
  explorer = { replace_netrw = true },
  image = { enabled = true },
  indent = { indent = { only_current = false, only_scope = true } },
  input = { enabled = true },
  -- notifier = require('nvim.snacks.notifier'),
  quickfile = { enabled = true },
  terminal = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = true },
  -- statuscolumn = require('nvim.snacks.statuscolumn'),
  picker = require('nvim.snacks.picker'),
  styles = require('nvim.snacks.styles'),
  words = { enabled = true },
})

--- 3. the rest of the owl
_G.nv = require('nvim')

--- 4. convert enabled plugins to `vim.pack` specs
---@type vim.pack.Spec[]
local specs = vim
  .iter(nv.plugins)
  :filter(function(t)
    return t.enabled ~= false
    -- return t.enabled == true end,
  end)
  :map(nv.plug --[[@as fun(table):vim.pack.Spec]])
  :totable()

--- 5. `packadd` plugins with custom loader for setup
if vim.v.vim_did_enter == 0 then
  vim.pack.add(specs, { load = nv.plug.load })
end

-- require('jit.p').stop()
