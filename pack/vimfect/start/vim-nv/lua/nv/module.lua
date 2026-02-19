local M = {}
local util = require('nvim.util')

--- Collect non-init Lua modules from a subdirectory of nvim/
---@param subdir string  subdir relative to nvim/ (empty string for root)
---@return table<string, true>
local function collect_modules(subdir)
  local modules = {}
  for _, modpath in ipairs(util.submodules(subdir)) do
    local name = modpath:match('([^/]+)$')
    if name then modules[name] = true end
  end
  return modules
end

M.automod = function()
  -- TODO: make sure it should be `2`
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
---@param fn fun(modname: string)   -- callback with the module name (e.g. "plug.mini.foo")
---@param subpath? string           -- optional subpath inside lua/, e.g. "plug/mini"
---@param recursive? boolean        -- recurse into subdirs if true
M.for_each_module = function(fn, subpath, recursive)
  local base = vim.fs.joinpath(vim.fn.stdpath('config'), 'lua')
  subpath = subpath or ''
  local pattern = vim.fs.joinpath(subpath, (recursive and '**' or '*'))
  local files = vim.fn.globpath(base, pattern, false, true)
  for _, f in ipairs(files) do
    local mod = util.modname(f)
    if not vim.endswith(mod, '/init') then
      fn(mod)
    end
  end
end

local root = 'nvim'
local dir = vim.fs.joinpath(vim.g.stdpath.config, 'lua', root)

-- top-level modules
local mods = collect_modules('')

-- one level of subdirs
for _, d in ipairs(vim.fn.globpath(dir, '*/', false, true)) do
  local subname = d:match('([^/]+)/$')
  if subname then
    local submods = collect_modules(subname)
    mods[subname] = next(submods) and submods or true
  end
end

return M
