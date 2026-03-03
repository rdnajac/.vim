local M = {}
local util = require('nvim.util')

local fn, fs, uv = vim.fn, vim.fs, vim.uv
-- local dir = fs.dirname(debug.getinfo(1).source:gsub('^@', ''))
-- local files = fn.globpath(dir, '*/init.lua', false, true)
-- vim.iter(files):map(function(file) return file:gsub('^.*(nvim/.+)$', '%1') end)
--   :map(fs.dirname):map(function(modname)
--     local submod = require(modname)
--     local key = fs.basename(modname)
--     M[key] = submod
--     return submod
--   end)

local luaroot = fs.joinpath(vim.g.stdpath.config, 'lua')

--- Returns true for .lua files (non-init) and dirs that have an init.lua
local function is_module(f)
  if vim.fn.isdirectory(f) == 1 then
    return vim.uv.fs_stat(f .. '/init.lua') ~= nil
  else
    return vim.endswith(f, '.lua') and not vim.endswith(f, 'init.lua')
  end
end

--- Get list of submodules in a given subdirectory of `nvim/`
---@param subdir string subdirectory of `nvim/` to search
---@return string[] list of module names ready for `require()`
M.submodules = function(subdir)
  local path = fs.joinpath(luaroot, 'nvim', subdir)
  local files = fn.globpath(path, '*', false, true)
  return vim.iter(files):filter(is_module):map(util.modname):totable()
end

--- Collect non-init Lua modules from a subdirectory of nvim/
---@param subdir string  subdir relative to nvim/ (empty string for root)
---@return table<string, true>
local function collect_modules(subdir)
  local modules = {}
  for _, modpath in ipairs(M.submodules(subdir)) do
    local name = modpath:match('([^/]+)$')
    if name then
      modules[name] = true
    end
  end
  return modules
end

M.automod = function()
  local me = debug.getinfo(2, 'S').source:sub(2)
  local dir = vim.fn.fnamemodify(me, ':p:h')
  local files = vim.fn.globpath(dir, '*', false, true)

  return vim
    .iter(files)
    :filter(function(f) return f ~= me end)
    :map(dofile)
    :map(function(t) return vim.islist(t) and t or { t } end)
    :fold({}, function(acc, v) return vim.list_extend(acc, v) end)
end

--- Iterate over modules under $XDG_CONFIG_HOME/nvim/lua
---@param cb fun(modname: string)    -- callback with the module name (e.g. "plug.mini.foo")
---@param subpath? string            -- optional subpath inside lua/, e.g. "plug/mini"
---@param recursive? boolean         -- recurse into subdirs if true
M.for_each_module = function(cb, subpath, recursive)
  subpath = subpath or ''
  local pattern = fs.joinpath(subpath, (recursive and '**' or '*'))
  local files = fn.globpath(luaroot, pattern, false, true)
  for _, f in ipairs(files) do
    local mod = util.modname(f)
    if not vim.endswith(mod, '/init') then
      cb(mod)
    end
  end
end

local root = 'nvim'
local dir = fs.joinpath(luaroot, root)

-- top-level modules
local mods = collect_modules('')

-- one level of subdirs
for _, d in ipairs(fn.globpath(dir, '*/', false, true)) do
  local subname = d:match('([^/]+)/$')
  if subname then
    local submods = collect_modules(subname)
    mods[subname] = next(submods) and submods or true
  end
end

M.mods = mods

return M
