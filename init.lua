local t0 = vim.uv.hrtime()

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.health = { style = 'float' }
for _, provider in ipairs({ 'node', 'perl', 'ruby' }) do
  vim.g[provider] = 0 -- disable providers to silence warnings
end

vim.o.cmdheight = 0
-- vim.o.pumblend = 0 -- default: 10
-- vim.o.smoothscroll = true -- default: false
vim.o.winborder = 'rounded'
-- vim.o.winborder = '+,-,+,|,+,-,+,|'

vim.loader.enable()

_G.nv = require('nvim')
nv.did = vim.defaulttable()
nv.spec = require('nvim.plug.spec')

-- nv.spec('_plugins')
-- TODO: Snacks.debug
_G.info = function(...)
  vim.notify(vim.inspect(...), vim.log.levels.INFO)
end

vim.cmd.runtime([[vimrc]])

for _, modname in ipairs({ 'copilot', 'diagnostic', 'lsp', 'treesitter', 'ui' }) do
  nv.spec(modname)
end

print(('nvim initialized in %.2f ms'):format((vim.uv.hrtime() - t0) / 1e6))
-- TODO: get the time to `VimEnter` event
