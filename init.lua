vim.loader.enable()
vim.pack.add({ vim.fn['git#repo']('folke/snacks.nvim') }, { confirm = false })
assert(require('snacks')) -- snack attack!

if vim.env.PROF then
  Snacks.profiler.startup({
    startup = { event = 'UIEnter' },
  })
end

vim.o.cmdheight = 0
vim.o.winborder = 'rounded'
require('vim._extui').enable({})

vim.cmd([[runtime vimrc]])

require('snacks').setup({
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
})

_G.dd = Snacks.debug.inspect
_G.bt = Snacks.debug.backtrace
_G.pp = Snacks.debug.profile

_G.nv = require('nvim.util')

nv.notify.setup()

nv.blink = require('nvim.blink')
nv.lsp = require('nvim.lsp')
nv.keymaps = require('nvim.keymaps')
nv.mini = require('nvim.mini')
nv.treesitter = require('nvim.treesitter')
nv.plugins = require('nvim.plugins')

_G.Plug = require('plug')

-- collect specs
nv.specs = vim
  .iter({ 'blink', 'lsp', 'keymaps', 'mini', 'treesitter', 'plugins' })
  :map(function(v) return nv[v].spec end)
  :flatten()
  :map(Plug --[[@as function]])
  :totable()

vim.pack.add(nv.specs, { load = Plug.load })

require('folke.tokyonight').setup()

vim.schedule(function()
  vim.lsp.enable(nv.lsp.servers())
  require('which-key').add(Plug.keys())
  require('munchies').setup({ toggles = Plug.toggles() })
end)
-- vim: fdm=syntax fdl=0 foldminlines=9
