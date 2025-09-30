local M = {}

vim.g.health = { style = 'float' }
-- for _, provider in ipairs({ 'node', 'perl', 'ruby' }) do
--   vim.g[provider] = 0 -- disable to silence warnings
-- end

M.commands = function()
  require('nvim.config.commands')
end

require('nvim.config.keymaps')

vim.o.winbar = '%{%v:lua.nv.winbar()%}'

return M
