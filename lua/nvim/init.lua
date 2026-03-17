_G.nv = setmetatable({}, {
  __newindex = function(t, k, v)
    rawset(t, k, v)
    if type(v) == 'table' then
      if v.specs then
        Plug(v.specs)
      end
      if vim.is_callable(v.after) then
        vim.schedule(v.after)
      end
    end
  end,
})

local fn, fs, uv = vim.fn, vim.fs, vim.uv
local luaroot = fs.joinpath(fn.stdpath('config'), 'lua')
local submodules = fn.globpath(luaroot, 'nvim/*/init.lua', false, true)

vim
  .iter(submodules)
  :map(function(fpath) return fpath:gsub('^.*(nvim/.+)$', '%1'):gsub('/init.lua$', '') end)
  :each(function(modname)
    local key = fs.basename(modname)
    nv[key] = require(modname)
    vim.keymap.set(
      'n',
      '\\\\' .. (key == 'util' and 'v' or key:sub(1, 1)),
      function() vim.fn['edit#luamod'](modname) end,
      { desc = 'Edit ' .. modname }
    )
  end)

return nv
