local mydir = vim.fs.dirname(debug.getinfo(1).source:sub(2))
local files = vim.fn.globpath(mydir, '*.lua', false, true)
local iter = vim.iter(files)

iter
  :filter(function(f)
    return not vim.endswith(f, 'init.lua')
  end)
  :map(nv.fn.modname)
  :each(function(mod)
    local submod = vim.fn.fnamemodify(mod, ':t')
    _G.nv[submod] = require(mod)
  end)
