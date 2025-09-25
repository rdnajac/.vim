local M = vim.defaulttable(function(k)
  -- return require(vim.fs.basename(vim.fs.dirname(debug.getinfo(1, 'S').source:sub(2))) .. '.' .. k)
  return require('nvim.' .. k)
  -- TODO: handle utils
end)

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

_G.nv = M
M.did = vim.defaulttable()
M.lazyload = require('nvim.util.lazyload')
local Plug = require('nvim._plugin').new
-- TODO: don't skip icons
local skip = { init = true, icon = true, util = true }
local dir = vim.fs.joinpath(vim.fn.stdpath('config'), 'lua', 'nvim')
local mods = {}

for name, _type in vim.fs.dir(dir) do
  local mod = name:match('^([%w%-]+)')
  if mod and not skip[mod] then
    mods[#mods + 1] = mod
  end
end

for i = #mods, 1, -1 do
  Plug(mods[i])
end

return M
