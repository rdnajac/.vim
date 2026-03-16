local uv = vim.uv
local fs = vim.fs
local me = debug.getinfo(1, 'S').source:sub(2)
local nvim_dir = fs.joinpath(vim.fn.stdpath('config'), 'lua', 'nvim')
local meta_file = fs.joinpath(nvim_dir, 'meta.lua')

local function scan_modules(dir)
  return vim
    .iter(fs.dir(dir or fs.dirname(me)))
    :map(function(entry, type_)
      if type_ == 'directory' then
        return entry
      end
    end)
    :totable()
end

local M = {}

---@return string[]
function M.meta()
  local lines = {
    '---@meta',
    "error('this file should not be required directly')",
    '',
  }
  vim.iter(scan_modules(nvim_dir)):each(
    function(name) table.insert(lines, string.format("nv.%s = require('nvim.%s')", name, name)) end
  )

  return lines
end

return M
