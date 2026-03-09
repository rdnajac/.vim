--- init.lua
local t_1 = vim.uv.hrtime()

vim.loader.enable()

if vim.env.PROF then
  vim.opt.rtp:append(vim.fn.stdpath('data') .. '/site/pack/core/opt/snacks.nvim')
  require('snacks.profiler').startup({ startup = { event = 'UIEnter' } })
end

require('nvim.ui.2')

-- exposes global `Plug` lua function
-- registers autocmd for build on install/update
require('plug')

-- vim.cmd([[ source ~/.vim/vimrc | lua vim.pack.add(vim.g.plugs) ]])
vim.cmd([[ source ~/.vim/vimrc ]])

require('snacks')
_G.dd = Snacks.debug.inspect
_G.bt = Snacks.debug.backtrace
_G.p = Snacks.debug.profile
Snacks.setup({
  bigfile = require('nvim.snacks.bigfile'),
  dashboard = require('nvim.snacks.dashboard'),
  explorer = { replace_netrw = false },
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
})

Plug(require('nvim.blink'))

--- Defines the structure of modules under the `nvim/` directory
---@class nv.Submodule
---@field specs plug.Spec[]
---@field after? fun():nil
---@field status? fun():string

---@type table<string, nv.Submodule>
_G.nv = {
  keys = require('nvim.keys'),
  lsp = require('nvim.lsp'),
  treesitter = require('nvim.treesitter'),
  ui = require('nvim.ui'),
  util = require('nvim.util'),
}

vim.iter(nv):each(function(_, v)
  -- vim.validate('submodule', v, 'table')
  if vim.is_callable(v.after) then
    vim.schedule(v.after)
  end
  Plug(v.specs) -- `vim.pack.add`s transformed plugins
end)

local elapsed = (vim.uv.hrtime() - t_1) / 1e6
local msg = ('_init.lua_: Loaded in **%s** ms'):format(elapsed)
vim.schedule(function() print(msg) end)
