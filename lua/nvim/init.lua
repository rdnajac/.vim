-- vim.g.use_uv = true
-- TODO: benchmark uv, vifn, and string methods

local self_path = debug.getinfo(1, 'S').source:sub(2)
-- local self_dir = vim.fn.fnamemodify(self_path, ':p:h')
-- local self_dir = vim.fs.dirname(vim.fs.abspath(self_path))
local self_dir = vim.fs.dirname(self_path)
local pattern = '*'
-- local files = vim.fn.globpath(self_dir, pattern, false, true)
-- print(vim.inspect(files))  

-- for file in vim.fs.find(pattern, { path = self_dir, limit = 1 }) do
--   print(file)
-- end  
-- collect files with vi.sidr
-- local files = {}

-- vim.g.use_uv = true
-- TODO: benchmark uv, vifn, and string methods

local self_path = debug.getinfo(1, 'S').source:sub(2)
-- local self_dir = vim.fn.fnamemodify(self_path, ':p:h')
-- local self_dir = vim.fs.dirname(vim.fs.abspath(self_path))
local self_dir = vim.fs.dirname(self_path)
local pattern = '*'
-- local files = vim.fn.globpath(self_dir, pattern, false, true)
local files = {}

-- local function modname(file)
--   return vim.fs.relpath(this_dir, file)
-- end
-- return vim.fn.fnamemodify(path, ':r:s?^.*/lua/??')
-- local submods = vim.tbl_map(function(file)
--   local lua_root = vim.fs.normalize(vim.fs.joinpath(vim.fn.stdpath('config'), 'lua'))
--   return vim.fs.relpath(lua_root, file)
-- end, files)
-- 
-- print(vim.inspect(submods))

return vim.defaulttable(function(k)
  return require('nvim.' .. k)
end)
