--- init.lua
--- 1. source vimrc
---  - relies on autoload/plug.vim to override vim-plug calls
---  - enables `vim.loader` and `vim.pack.add`s base plugins
vim.cmd([[runtime vimrc]])

--- 2. expose and setup `Snacks`
require('snacks')
assert(Snacks)

-- declare global debug helpers
_G.bt = Snacks.debug.backtrace
_G.dd = Snacks.debug.inspect
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

-- TODO: cache result as colorscheme so we don't have to setup each time
--- 3. setup theme early
require('folke.tokyonight').setup()

--- 4. global state
_G.nv = require('nvim')

--- 5. load plugins, keys, toggles
local plugins = require('plugins')
local keys = require('nvim.keys.extra')
local toggles = require('nvim.keys.toggles')

--- 6. iterate over plugins to build specs, keys, toggles
local specs = vim
  .iter(plugins)
  :map(nv.plug --[[@as fun(k: string, v: table): Plugin]])
  :filter(function(p) return p.enabled ~= false end)
  :map(function(p)
    -- collect keys and toggles
    vim.list_extend(keys, p.keys or {})
    vim.tbl_extend('error', toggles, p.toggles or {})
    return p
  end)
  :map(function(p) return p:tospec() end)
  :totable()

--- 7. load plugins, keys, toggles before UIEnter
if vim.v.vim_did_enter == 0 then
  vim.pack.add(specs, { load = nv.plug.load })
  vim.schedule(function()
    nv.keys.add(keys)
    nv.keys.register_toggles(toggles)
  end)
end

--- vim: fdl=0 fdm=expr foldminlines=9
