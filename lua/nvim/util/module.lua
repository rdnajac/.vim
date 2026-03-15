-- functions for lua modules
local M = {}

local luaroot = fs.joinpath(vim.g.stdpath.config, 'lua')

--- Convert a file path to a module name by trimming the lua root
---@param path string
---@return string
M.name = function(path)
  -- return fn.fnamemodify(path, ':r:s?^.*/lua/??'):gsub('/init$', '')
  local modname = path:gsub('^.*/lua/', ''):gsub('/init.lua$', '')
  -- return fn.fnamemodify(path, ':r:s?^.*/lua/??'):gsub('/init$', '')
  return modname
end

M.yank = function()
  local file = vim.api.nvim_buf_get_name(0)
  local modname = M.name(file)
  local line = string.format([[require('%s')]], modname)
  nv.util.yank(line)
end

-- local original_require = require
-- local verbose_require = function(modname)
--   print(([[require('%s')]]):format(modname))
--   return original_require(modname)
-- end
-- require = verbose_require

return M
