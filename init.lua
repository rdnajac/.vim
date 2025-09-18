local t0 = vim.uv.hrtime() -- capture the start time

vim.loader.enable()

vim.o.cmdheight = 0
vim.o.laststatus = 3
vim.o.pumblend = 0
-- vim.o.smoothscroll = true
vim.o.winborder = 'rounded'
_G.nv = require('nvim')
-- _G.nv = vim.defaulttable(function(k)
--   return require('nvim.' .. k)
-- end)
require('nvim.ui.extui')

_G.info = function(...)
  vim.notify(vim.inspect(...), vim.log.levels.INFO)
end
-- nv.notify.setup() -- optionally, override vim.notify
vim.cmd.runtime([[vimrc]])
-- info(vim.tbl_keys(package.loaded))

local Plugin = require('nvim.plug.spec')

-- TODO: turn these into plugins
for _, modname in ipairs({ 'copilot', 'diagnostic', 'lsp', 'treesitter', 'ui' }) do
  local plugin = Plugin(modname)
  plugin:init() -- setup, deps, after
end

_G.startuptime = (vim.uv.hrtime() - t0) / 1e6
print(('nvim initialized in %.2f ms'):format(startuptime))
-- require('nvim.util.startuptime')

vim.g.health = { style = 'float' }
-- disable external providers to silence checkhealth warnings
for _, provider in ipairs({ 'node', 'perl', 'ruby' }) do
  vim.g[provider] = 0
end

---@type 'netrw'|'snacks'|'oil'
vim.g.file_explorer = 'oil'
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
