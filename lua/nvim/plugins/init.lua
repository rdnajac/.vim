local path = vim.fs.dirname(debug.getinfo(1).source:sub(2))
local files = vim.fn.globpath(path, '*', false, true)
local iter = vim.iter(files)
local plugins = iter
  :filter(function(f)
    return not vim.endswith(f, 'init.lua')
  end)
  :map(dofile)
  :map(function(mod)
    return vim.islist(mod) and mod or { mod }
  end)
  :flatten()
  :totable()

return plugins
