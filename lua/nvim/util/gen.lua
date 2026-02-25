local uv = vim.uv
local fs = vim.fs
local base_dir = fs.dirname(fs.dirname(fs.abspath(debug.getinfo(1, 'S').source:sub(2))))
local nvim_dir = fs.joinpath(base_dir, 'lua', 'nvim')
local meta_file = fs.joinpath(base_dir, 'lua', 'nvim', 'meta.lua')

--- Scan for top-level modules and util submodules
---@return {toplevel: string[], util: string[]}
local function scan_modules()
  local toplevel = {}
  local util_modules = {}

  -- Scan top-level
  local handle = uv.fs_scandir(nvim_dir)
  if handle then
    while true do
      local name, type = uv.fs_scandir_next(handle)
      if not name then
        break
      end

      if type == 'directory' and name ~= 'util' then
        local init_path = nvim_dir .. '/' .. name .. '/init.lua'
        if uv.fs_stat(init_path) then
          table.insert(toplevel, name)
        end
      end
    end
  end

  -- Scan util directory
  local util_dir = nvim_dir .. '/util'
  local util_handle = uv.fs_scandir(util_dir)
  if util_handle then
    while true do
      local name, type = uv.fs_scandir_next(util_handle)
      if not name then
        break
      end

      if type == 'file' and name:match('%.lua$') then
        local module = name:gsub('%.lua$', '')
        if module ~= 'init' and not module:match('^_') then
          table.insert(util_modules, module)
        end
      elseif type == 'directory' then
        local init_path = util_dir .. '/' .. name .. '/init.lua'
        if uv.fs_stat(init_path) then
          table.insert(util_modules, name)
        end
      end
    end
  end
  table.sort(toplevel)
  table.sort(util_modules)
  return { toplevel = toplevel, util = util_modules }
end

local M = {}

---@return string[]
function M.generate_meta()
  local modules = scan_modules()

  local lines = {
    '---@meta',
    "error('this file should not be required directly')",
    '',
  }
  -- Top-level modules
  for _, name in ipairs(modules.toplevel) do
    table.insert(lines, string.format("nv.%s = require('nvim.%s')", name, name))
  end

  -- Empty line separator
  table.insert(lines, '')

  -- Util modules
  for _, name in ipairs(modules.util) do
    table.insert(lines, string.format("nv.%s = require('nvim.util.%s')", name, name))
  end

  return lines
end

return M
