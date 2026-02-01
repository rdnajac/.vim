--- init.lua
-- require('jit.p').start('ri1', '/tmp/profile')
--- 1. source vimrc
---  - relies on autoload/plug.vim to override vim-plug calls
---  - enables `vim.loader` and `vim.pack.add`s base plugins
vim.cmd([[ runtime vimrc ]])

--- 2. snack attack!
require('snacks')
_G.dd = Snacks.debug.inspect
_G.bt = Snacks.debug.backtrace
_G.p = Snacks.debug.profile

-- optional profiling
if vim.env.PROF then
  Snacks.profiler.startup({
    startup = { event = 'UIEnter' },
  })
end

---@type snacks.Config
local opts = {
  bigfile = require('folke.snacks.bigfile'),
  dashboard = require('folke.snacks.dashboard'),
  explorer = { replace_netrw = true },
  image = { enabled = true },
  indent = { indent = { only_current = false, only_scope = true } },
  input = { enabled = true },
  -- notifier = require('folke.snacks.notifier'),
  quickfile = { enabled = true },
  scratch = { template = 'local x = \n\nprint(x)' },
  terminal = { enabled = true },
  scope = {
    keys = {
      textobject = {
        ii = { min_size = 2, edge = false, cursor = false, desc = 'inner scope' },
        ai = { min_size = 2, cursor = false, desc = 'full scope' },
        -- ag = { min_size = 1, edge = false, cursor = false, treesitter = { enabled = false }, desc = "buffer" },
      },
      jump = {
        ['[i'] = { min_size = 1, bottom = false, cursor = false, edge = true },
        [']i'] = { min_size = 1, bottom = true, cursor = false, edge = true },
      },
    },
  },
  scroll = { enabled = true },
  statuscolumn = require('folke.snacks.statuscolumn'),
  picker = require('folke.snacks.picker'),
  styles = {
    lazygit = { height = 0, width = 0 },
    terminal = { wo = { winhighlight = 'Normal:Character' } },
    notification_history = { height = 0.9, width = 0.9, wo = { wrap = false } },
  },
  words = { enabled = true },
}
Snacks.setup(opts)

--- 3. expose global config table
--- - sets up ui2 (`_extui`)
--- - lazily loads utility modules
_G.nv = require('nvim')

--- 5. import plug module convert plugins table to specs
local Plug = require('plug')
local plugins = require('plugins')
local specs = Plug.to_spec(plugins)

--- 6. `packadd` plugins with custom loader for setup
if vim.v.vim_did_enter == 0 then
  vim.pack.add(specs, { load = Plug._load })
end
-- require('jit.p').stop()
-- vim: fdl=0 fdm=expr
