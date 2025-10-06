local M = {}

--- Extract module name from file path
--- Converts a file path like '/path/to/lua/foo/bar.lua' to 'foo.bar'
--- @param filepath string
--- @return string|nil
function M.modname(filepath)
  return vim.fn.fnamemodify(filepath, ':r:s?^.*/lua/??')
end

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
---
--- from shared.lua
--- @generic T
--- @param root string
--- @param mod T
--- @return T
M.defer_require = function(root, mod)
  return setmetatable({ _submodules = mod }, {
    ---@param t table<string, any>
    ---@param k string
    __index = function(t, k)
      if not mod[k] then
        return
      end
      local name = string.format('%s.%s', root, k)
      t[k] = require(name)
      return t[k]
    end,
  })
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

--- Load all modules from a directory, returning successfully loaded modules
--- @param module_dir string Directory path containing Lua modules
--- @param module_prefix string Module name prefix (e.g., 'nvim.plugins')
--- @return table<string, any> modules Map of module names to loaded modules
M.load_modules = function(module_dir, module_prefix)
  local modules = {}
  local lua_files = vim.fn.globpath(module_dir, '*.lua', false, true)
  
  for _, filepath in ipairs(lua_files) do
    local filename = filepath:match('([^/]+)%.lua$')
    if filename and filename ~= 'init' then
      local module_name = module_prefix .. '.' .. filename
      local ok, module_result = pcall(require, module_name)
      if ok and module_result then
        modules[filename] = module_result
      end
    end
  end
  
  return modules
end

return M
