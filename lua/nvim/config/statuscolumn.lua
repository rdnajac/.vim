-- Native statuscolumn configuration
-- This module sets up the native statuscolumn implementation

local M = {}

function M.setup()
  -- Set the statuscolumn option to use our native implementation
  vim.o.statuscolumn = "%!v:lua.require'nvim.util.native_statuscolumn'.get()"
end

return M
