--- init.lua
--- 1. source vimrc
---  - relies on autoload/plug.vim to override vim-plug calls
---  - enables `vim.loader` and `vim.pack.add`s base plugins
vim.cmd([[ runtime vimrc | colorscheme tokyonight_generated ]])

--- 2. snack attack!
require('snacks')
-- _G.bt = Snacks.debug.backtrace
_G.dd = Snacks.debug.inspect
-- _G.p = Snacks.debug.profile

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

--- 3. global config state
_G.nv = require('nvim')

--- 4. import plugin table and convert to specs
nv.specs = vim
  .iter(require('plugins'))
  :filter(function(_, v) return v.enabled ~= false end)
  :map(require('plug') --[[@as fun()]])
  :totable()

--- 5. `packadd` plugins with custom loader for setup
---@param plug_data {spec: vim.pack.Spec, path: string}
local function _load(plug_data)
  vim.cmd.packadd({ plug_data.spec.name, bang = true })
  return vim.tbl_get(plug_data.spec, 'data', 'setup')()
end

vim.pack.add(nv.specs, { load = _load })
-- vim: fdl=0 fdm=expr
