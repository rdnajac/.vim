local M = vim.defaulttable(function(k)
  return require(vim.fs.basename(vim.fs.dirname(debug.getinfo(1, 'S').source:sub(2))) .. '.' .. k)
  -- return require('nvim.' .. k)
end)

require('vim._extui').enable({}) -- XXX: experimental

M.did = vim.defaulttable()
M.lazyload = require('nvim.util.lazyload')
M.spec = require('nvim.plug.spec')

-- local submodules = vim.loader.find('*', {all = true})
-- print(submodules)
print(vim.api.nvim_get_runtime_file('lua/nvim/*.lua', true))

return M
