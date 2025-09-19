local t0 = vim.uv.hrtime() -- capture the start time

vim.loader.enable()

vim.o.cmdheight = 0
vim.o.pumblend = 0
vim.o.winborder = 'rounded'
-- vim.o.smoothscroll = true

_G.nv = require('nvim')
nv.did = vim.defaulttable()
nv.spec = require('nvim.plug.spec')


_G.info = function(...)
  vim.notify(vim.inspect(...), vim.log.levels.INFO)
end

local Plugin = require('nvim.plug.spec')
-- Plugin('_plugins'):load()
vim.cmd.runtime([[vimrc]])


-- TODO: turn these into plugins
for _, modname in ipairs({ 'copilot', 'diagnostic', 'lsp', 'treesitter', 'ui' }) do
  Plugin(modname):load()
end

vim.g.health = { style = 'float' }
-- disable external providers to silence checkhealth warnings
for _, provider in ipairs({ 'node', 'perl', 'ruby' }) do
  vim.g[provider] = 0
end

---@type 'netrw'|'snacks'|'oil'
vim.g.file_explorer = 'oil'
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

print(('nvim initialized in %.2f ms'):format((vim.uv.hrtime() - t0) / 1e6))
