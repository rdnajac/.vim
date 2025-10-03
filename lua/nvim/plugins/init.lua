local M = {}

local dir = nv.stdpath.config .. '/lua/nvim/plugins'
local files = vim.fn.globpath(dir, '*.lua', false, true)
local iter = vim.iter(files)

iter
  :map(function(path)
    return path:match('^.+/(.+)%.lua$')
  end)
  :filter(function(name)
    return name ~= 'init'
  end)
  :map(function(name)
    local t = require('nvim.plugins.' .. name)
    return vim.islist(t) and t or { t }
  end)
  :flatten()
  :each(function(spec)
    require('nvim.util.plug')(spec)
  end)

return M
