--- init.lua
--- 1. source vimrc
---  - relies on autoload/plug.vim to override vim-plug calls
---  - enables `vim.loader` and `vim.pack.add`s base plugins
vim.cmd([[ runtime vimrc | colorscheme tokyonight_generated ]])

--- 2. snack attack!
require('snacks')
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

--- 3. global state, overrides, nightly features
_G.nv = require('nvim')
-- vim.notify = nv.notify

--- 4. load the plugin table and convert to specs
local specs = vim
  .iter(require('plugins'))
  :filter(function(_, v) return v.enabled ~= false end)
  :map(require('plug') --[[@as fun()]])
  :map(function(p) return p:tospec() end)
  :totable()

require('vim._extui').enable({})
--- 5. add plugins via `vim.pack.add` with custom loader
--- that calls the plugin's setup function with opts table
---@param plug_data {spec: vim.pack.Spec, path: string}
local _load = function(plug_data)
  vim.cmd.packadd({ plug_data.spec.name, bang = true })
  vim.tbl_get(plug_data, 'spec', 'data', 'setup')()
end

-- TODO: alternatively, use default load and call each setup after
-- since the table containing the setup function is already cached
vim.pack.add(specs, { load = _load })

-- BUG: ui2 error on declining to install
vim.o.cmdheight = 0 -- XXX: experimental!
require('vim._extui').enable({})

-- vim: fdl=0 fdm=expr foldminlines=9
