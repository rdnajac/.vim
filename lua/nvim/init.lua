local M = {}

_G.nv = setmetatable(M, {
  __index = function(t, k)
    t[k] = require('nvim.' .. k)
    return rawget(t, k) -- does this stop nested metatable __index?
  end,
})

_G.dd = function(...)
  require('snacks.debug').inspect(...)
end
_G.bt = function(...)
  require('snacks.debug').backtrace(...)
end
_G.p = function(...)
  require('snacks.debug').profile(...)
end
--- @diagnostic disable-next-line: duplicate-set-field
vim._print = function(_, ...)
  dd(...)
end

local Plug = require('nvim._plugin').new

local skip = { init = true, util = true }
local dir = vim.fs.joinpath(vim.fn.stdpath('config'), 'lua', 'nvim')
for name, _type in vim.fs.dir(dir) do
  local modname = name:match('^([%w%-]+)')
  if modname and not skip[modname] then
  print(modname)
    -- track('plug: ' .. modname, require('nvim._plugin').new(modname))
  end
end

Plug('Snacks')
Plug('tokyonight')
Plug('which-key')
Plug('lsp')
Plug('blink')
Plug('mini')
Plug('config')
-- Plug('copilot')
Plug('diagnostic')
-- Plug('dial')
-- Plug('flash')
-- Plug('notify')
Plug('plug')
-- Plug('r')
-- Plug('render-markdown')
-- Plug('todo-comments')
-- Plug('treesitter')
-- Plug('ui')
Plug('oil')

return M
