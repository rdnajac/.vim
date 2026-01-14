vim.loader.enable()

if vim.env.PROF then
  require('folke.snacks.profiler')
end

_G.dd = function(...) return Snacks and Snacks.debug.inspect(...) or vim.print(...) end
_G.bt = function(...) return Snacks and Snacks.debug.backtrace(...) or dd() end
_G.pp = function(...) return Snacks and Snacks.debug.profile(...) or nv.debug.profile(...) end

vim.o.cmdheight = 0
vim.o.winborder = 'rounded'
require('vim._extui').enable({})

vim.cmd([[runtime vimrc]])

require('snacks').setup({
  bigfile = require('folke.snacks.bigfile'),
  dashboard = require('folke.snacks.dashboard'),
  explorer = { replace_netrw = true },
  image = { enabled = true },
  indent = { indent = { only_current = true, only_scope = true } },
  input = { enabled = true },
  notifier = require('folke.snacks.notifier'),
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

require('folke.snacks')
require('folke.tokyonight').setup()

_G.nv = require('nvim')
_G.Plug = require('plug')

-- plug begin
vim.iter(nv.specs):each(Plug) --[[@as function]]
-- plug end
vim.pack.add(Plug.specs(), { load = Plug.load })

-- TODO: encapsulate
vim.schedule(function()
  require('which-key').add(Plug.keys())
  -- nv.keymaps.register(Plug.keys())

  local toggles = vim.tbl_extend('error', Plug.toggles(), require('folke.snacks.toggles'))
  for key, v in pairs(toggles) do
    local type_ = type(v)
    if type_ == 'table' then
      Snacks.toggle.new(v):map(key)
    elseif type_ == 'string' then
      Snacks.toggle.option(v):map(key)
    elseif type_ == 'function' then
      v():map(key) -- preset toggles
    end
  end
end)
