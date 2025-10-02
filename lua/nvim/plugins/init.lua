local M = {}

local dir = vim.fn.stdpath('config') .. '/lua/nvim/plugins'
local files = vim.fn.globpath(dir, '*.lua', false, true)

for _, path in ipairs(files) do
  local name = path:match('^.+/(.+)%.lua$')
  if name ~= 'init' then
    local t = require('nvim.plugins.' .. name)
    if vim.islist(t) and type(t[1]) ~= 'string' then
      vim.list_extend(M, t)
    else
      table.insert(M, t)
    end
  end
end

return M
