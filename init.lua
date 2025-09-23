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

_G.nv = require('nvim')
_G.info = function(...) -- TODO: Snacks.debug
  vim.notify(vim.inspect(...), vim.log.levels.INFO)
end

-- TODO: move this to vimrc
for _, modname in ipairs({ 'tokyonight', 'which-key', 'snacks' }) do
  nv.spec(modname)
end

local plugins = {
  'blink.cmp',
  'copilot',
  'diagnostic',
  'dial',
  'flash',
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

print(('nvim initialized in %.2f ms'):format((vim.uv.hrtime() - vim.g.t0) / 1e6))
-- TODO: get the time to `VimEnter` event
