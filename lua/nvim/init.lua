local M = {}

_G.nv = setmetatable({}, {
  __index = function(t, k)
    t[k] = require('nvim.' .. k)
    return rawget(t, k)
  end,
})

vim.o.winborder = 'rounded'
vim.o.cmdheight = 0
require('vim._extui').enable({})

for _, plugin in ipairs({
  'tokyonight',
  'snacks',
  'which-key',
  'mini',
  'oil',
}) do
  nv.plug(nv[plugin])
end
-- nv.icons = require().icons

-- print(vim.tbl_keys(nv.config))

return M
