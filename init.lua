vim.g.t0 = vim.uv.hrtime()
vim.g.transparent = true
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.health = { style = 'float' }
for _, provider in ipairs({ 'node', 'perl', 'ruby' }) do
  vim.g[provider] = 0 -- disable providers to silence warnings
end

vim.loader.enable()

vim.cmd.runtime([[vimrc]])
vim.cmd([[color scheme]])

_G.nv = require('nvim')

local plugins = {
  'snacks',
  'which-key',
  'blink.cmp',
  'copilot',
  'diagnostic',
  'dial',
  'lsp',
  'mason',
  'mini',
  'oil',
  'plug',
  'r',
  'render-markdown',
  'todo-comments',
  'treesitter',
  'ui',
}
for _, modname in ipairs(plugins) do
  nv.spec(modname)
end

require('nvim.util.sourcecode')
-- require('nvim.util.extmarks')

-- local spec = require('nvim.plugin.folke')[1]
-- nv.spec(spec)

print(('nvim initialized in %.2f ms'):format((vim.uv.hrtime() - vim.g.t0) / 1e6))
-- TODO: get the time to `VimEnter` event
