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
-- vim.cmd([[color scheme]])

_G.nv = require('nvim')

local plugins = {
  'tokyonight',
  'snacks',
  'blink.cmp',
  'copilot',
  'diagnostic',
  'dial',
  'lsp',
  'mason',
  'mini',
  'oil',
  -- 'plug',
  'vim-plug',
  'r',
  'render-markdown',
  'todo-comments',
  'treesitter',
  'ui',
  'which-key',
}
for _, plugin in ipairs(plugins) do
  nv.plug(plugin)
end

require('nvim.util.sourcecode')
-- require('nvim.`util`.extmarks')

nv.plug(require('nvim.plugin.folke')[1])

print(('nvim initialized in %.2f ms'):format((vim.uv.hrtime() - vim.g.t0) / 1e6))
-- TODO: get the time to `VimEnter` event
