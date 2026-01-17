vim.loader.enable()

-- vim.pack.add({ nv.gh('folke/snacks.nvim') })
vim.pack.add({ 'https://github.com/folke/snacks.nvim.git' })
assert(require('snacks')) -- snack attack!
-- _G.dd = Snacks.debug.inspect
_G.dd = function(...) return Snacks.debug.inspect(...) end
_G.bt = Snacks.debug.backtrace
_G.pp = Snacks.debug.profile
if vim.env.PROF then
  Snacks.profiler.startup({
    startup = { event = 'UIEnter' },
  })
end

vim.o.cmdheight = 0
vim.o.winborder = 'rounded'
require('vim._extui').enable({})

vim.cmd([[runtime vimrc]])

require('folke.snacks').config()
require('folke.tokyonight').setup()

_G.nv = require('nvim')

local plugins = require('nvim.plugins')

for k, v in pairs(nv) do
  vim.list_extend(plugins, v.spec)
end

_G.Plug = require('plug')
local specs = vim.iter(plugins):map(Plug):totable()

vim.pack.add(specs, { load = Plug.load })

-- overrides
-- local vim_print = vim.print
-- print = vim.print
-- vim.print = Snacks.debug.inspect
vim.notify = nv.notify

vim.lsp.enable(nv.lsp.servers())
require('which-key').add(Plug.keys())
require('munchies').setup({ toggles = Plug.toggles() })
vim.g.render_markdown_config = nv.md

-- vim: fdm=syntax fdl=0 foldminlines=9
