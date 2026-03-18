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

nv.fs = require('nvim.fs')
nv.keys = require('nvim.keys')
nv.lsp = require('nvim.lsp')
nv.treesitter = require('nvim.treesitter')
nv.ui = require('nvim.ui')
nv.util = require('nvim.util')

vim.iter(nv):each(function(k)
  vim.keymap.set(
    'n',
    'gl' .. (k == 'util' and 'v' or k:sub(1, 1)),
    function() vim.fn['edit#luamod']('nvim/' .. k) end,
    { desc = 'Edit ' .. k }
  )
end)

return nv
