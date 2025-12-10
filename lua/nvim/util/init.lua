local M = vim.defaulttable(function(k)
  return require('nvim.util.' .. k)
end)

M.import = function(modname)
  -- local module = require(modname)
  local module = nv.fn.xprequire(modname)
  if type(module) == 'table' then
    local key = modname:match('([^./]+)$')
    rawset(M, key, module)
  end
  return module
end

M.submodules = function()
  -- NOTE: use `debug.getinfo(2)`, the caller’s stack frame
  local path = vim.fs.dirname(debug.getinfo(2).source:sub(2))
  local files = vim.fn.globpath(path, '*', false, true)
  return vim
    .iter(files)
    :filter(function(f)
      return not vim.endswith(f, 'init.lua')
    end)
    :map(nv.fn.modname)
    :totable()
end

return M
