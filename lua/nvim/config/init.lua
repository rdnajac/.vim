local M = {}

vim.g.health = { style = 'float' }
-- for _, provider in ipairs({ 'node', 'perl', 'ruby' }) do
--   vim.g[provider] = 0 -- disable to silence warnings
-- end

vim.schedule(function()
  require('nvim.config.commands')
  require('nvim.config.keymaps')
  require('nvim.config.autocmds')
  require('nvim.config.diagnostic')

  vim.o.winbar = '%{%v:lua.nv.winbar()%}'
end)

return M
