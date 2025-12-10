local M = vim.defaulttable(function(k)
  return require('nvim.util.' .. k)
end)

M.import = function(modname)
  local module = require(modname)
  if type(module) == 'table' then
    local key = modname:match('([^./]+)$')
    rawset(M, key, module)
  end
  return module
end


return M
