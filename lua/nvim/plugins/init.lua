local M = {
  require('nvim.snacks'),
}

vim.tbl_map(function(mod)
  vim.list_extend(M, require('nvim.' .. mod).spec)
end, {
  'lazy',
  'lsp',
  'treesitter',
})

local path = vim.fs.dirname(debug.getinfo(1).source:sub(2))
local files = vim.fn.globpath(path, '*.lua', false, true)
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

return vim.list_extend(M, plugins)
