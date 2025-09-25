local M = vim.defaulttable(function(k)
  -- return require(vim.fs.basename(vim.fs.dirname(debug.getinfo(1, 'S').source:sub(2))) .. '.' .. k)
  return require('nvim.' .. k)
  -- TODO: handle utils
end)
M.lazyload = require('nvim.util.lazyload')

_G.nv = M
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

M.did = vim.defaulttable()

local Plug = require('nvim._plugin').new
-- TODO: don't skip icons
local skip = { init = true, icons = true, util = true }
local dir = vim.fs.joinpath(vim.fn.stdpath('config'), 'lua', 'nvim')
local mods = {}

for name, _type in vim.fs.dir(dir) do
  local mod = name:match('^([%w%-]+)')
  if mod and not skip[mod] then
    mods[#mods + 1] = mod
  end
end

lap('init plugs')

-- TODO: check bottlenecks in r, mason, blink
for i = #mods, 1, -1 do
  local mod = mods[i]
  Plug(mod)
end

return M
