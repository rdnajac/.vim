vim.g.t0 = vim.uv.hrtime()
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
_G.info = function(...) -- TODO: Snacks.debug
  vim.notify(vim.inspect(...), vim.log.levels.INFO)
end

-- print(vim.api.nvim_get_runtime_file('lua/nvim/*.lua', true))
local plugins = {
  'tokyonight',
  'which-key',
  'snacks',
  -- 'todo-comments',
  'flash',
  'oil',
  'mini',
  'r',
  'render-markdown',
  'mason',
  'dial',
  'blink.cmp',
  'copilot',
  'diagnostic',
  'lsp',
  'plug',
  'treesitter',
  'ui',
}
for _, modname in ipairs(plugins) do
  nv.spec(modname)
end

vim.cmd.runtime([[vimrc]])
print(('nvim initialized in %.2f ms'):format((vim.uv.hrtime() - vim.g.t0) / 1e6))
-- TODO: get the time to `VimEnter` event
