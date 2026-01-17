local M = {}

function M.info(module)
  module = module:gsub('%.', '/')
  local root = vim.fs.root(vim.api.nvim_buf_get_name(0), 'lua') or vim.fn.getcwd()
  for _, fname in ipairs({ module, vim.fs.joinpath(root, 'lua', module) }) do
    for _, suf in ipairs({ '.lua', '/init.lua' }) do
      local path = fname .. suf
      if vim.uv.fs_stat(path) then
        return path
      end
    end
  end
  local modInfo = vim.loader.find(module)[1]
  return modInfo and modInfo.modpath or module
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
    local mod = M.modname(f)
    if not vim.endswith(mod, '/init') then
      fn(mod)
    end
  end
end

-- TODO: rewrite using the functions in this module
local root = 'nvim'
local dir = vim.g.stdpath.config .. '/lua/' .. root
local mods = {}

-- top-level .lua files
for _, f in ipairs(vim.fn.globpath(dir, '*.lua', false, true)) do
  local name = f:match('([^/]+)%.lua$')
  if name and name ~= 'init' then
    mods[name] = true
  end
end

-- one level of subdirs
for _, d in ipairs(vim.fn.globpath(dir, '*/', false, true)) do
  local subname = d:match('([^/]+)/$')
  if subname then
    local submods = {}
    for _, f in ipairs(vim.fn.globpath(d, '*.lua', false, true)) do
      local child = f:match('([^/]+)%.lua$')
      if child and child ~= 'init' then
        submods[child] = true
      end
    end
    if next(submods) then
      mods[subname] = submods
    else
      mods[subname] = true
    end
  end
end

return M
