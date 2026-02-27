-- -- init.lua

-- --- optional LuaJIT profiling
-- --- https://luajit.org/ext_profiler.html
-- -- require('jit.p').start('ri1', '/tmp/prof')

-- --- overrides `loadfile()` and default nvim package loader
-- --- https://github.com/neovim/neovim/discussions/36905
-- vim.loader.enable()

-- --- source vimrc
-- --- - `autoload/plug.vim` overrides vim-plug
-- --- - `plug#end()` will `vim.pack.add` vim plugins
-- vim.cmd([[ runtime vimrc ]])

--- snack attack!
-- require('snacks')
-- assert(Snacks)
-- _G.dd = Snacks.debug.inspect
-- _G.bt = Snacks.debug.backtrace
-- _G.p = Snacks.debug.profile
-- if vim.env.PROF then
-- Snacks.profiler.startup({ startup = { event = 'UIEnter' } })
-- end

local opts = {
  bigfile = require('nvim.snacks.bigfile'),
  dashboard = require('nvim.snacks.dashboard'),
  explorer = { replace_netrw = true },
  image = { enabled = true },
  indent = { indent = { only_current = false, only_scope = true } },
  input = { enabled = true },
  -- notifier = require('nvim.snacks.notifier'),
  quickfile = { enabled = true },
  picker = require('nvim.snacks.picker'),
  -- terminal = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = true },
  -- statuscolumn = require('nvim.snacks.statuscolumn'),
  -- styles = { notification_history = { height = 0.9, width = 0.9, wo = { wrap = false } } },
  toggle = { which_key = false },
  words = { enabled = true },
}

_G.nv = require('nvim')

---@type plug.Spec[]
local speclist = vim.list_extend({ { 'folke/snacks.nvim', opts = opts } }, require('nvim._plugins'))
local plugins = vim.iter(nv):fold(speclist, function(acc, k, v)
  vim.validate('after', v.specs, 'table')
  vim.validate('specs', v.after, vim.is_callable)
  -- if not v.specs then
  -- print(k)
  -- end
  vim.schedule(v.after) -- run after startup
  -- return vim.list_extend(acc, v.specs or {})
  return vim.list_extend(acc, v.specs)
end)

---@type vim.pack.Spec[]
local specs = vim
  .iter(plugins)
  :filter(function(t) return t.enabled ~= false end)
  :map(
    ---@param t plug.Spec
    ---@return vim.pack.Spec
    function(t) return require('nvim.plug').spec(t):pack() end
  )
  :totable()

local init = function() vim.pack.add(specs, { load = nv.plug.load }) end

init()

-- FIXME:
-- vim.schedule(init)

-- require('jit.p').stop()
