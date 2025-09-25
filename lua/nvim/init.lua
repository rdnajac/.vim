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

local seen = {}
for name, _type in vim.fs.dir(dir) do
  local modname = name:match('^([%w%-]+)')
  if modname and not skip[modname] then
    Plug(modname)
    track(modname)
    local char_idx = modname:sub(1, 1)
    -- print(char_idx .. ': ' .. modname)
    if not vim.tbl_contains(seen, char_idx) then
      seen[#seen + 1] = char_idx
    --   vim.keymap.set('n', '<Bslash>' .. char_idx, function()
    --     vim.cmd.edit(file_to_edit)
    --   end, { desc = 'Edit ' .. m.modname })
    else
      -- print('skipping ' .. modname)
    end
  end
end

return M
