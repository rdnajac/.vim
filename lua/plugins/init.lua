---@type (string | vim.pack.Spec)[]
local specs = {}
local plug = require('nvim.plug')

---@type table<string, PluginSpec>
M = setmetatable({}, {
  __call = function()
    -- TOOD: check if `vim.list.unique` is available
    return vim.list.unique(specs)
  end,

  __newindex = function(t, modname, mod)
    local key = mod.name or modname
    rawset(t, key, mod)

    local spec = plug.to_spec(mod)
    if spec then
      specs[#specs + 1] = spec
    end

    if type(mod.dependencies) == 'table' then
      for _, dep in ipairs(mod.dependencies) do
        local dep_spec = plug.to_spec(dep)
        if dep_spec then
          specs[#specs + 1] = dep_spec
        end
      end
    end
  end,
})

-- Determine current directory and Lua root
local this_file = debug.getinfo(1, 'S').source:sub(2) -- remove leading '@' or '='
local this_dir = assert(vim.fs.dirname(this_file), 'could not resolve current directory')
local lua_root = vim.fs.root(this_file, function(_, path)
  return path:match('/lua$') ~= nil
end) or this_dir

-- Require and register a plugin module by absolute path
---@param path string
local function plug(path)
  local modname = path
    :sub(#lua_root + 2) -- +2 to remove the leading `./` or `/`
    :gsub('%.lua$', '') -- remove .lua extension
  -- :gsub('/', '.') -- replace slashes with dots
  -- :gsub('^%.*', '') -- remove leading dots
  local ok, mod = pcall(require, modname)
  if not ok then
    vim.notify('Failed to require "' .. modname .. '": ' .. mod, vim.log.levels.ERROR)
    return
  end
  if mod.enabled == false or (type(mod.enabled) == 'function' and not mod.enabled()) then
    return
  end
  -- ~/.local/neovim/share/nvim/runtime/lua/vim/pack.lua:238
  local name = (mod.name or mod.src or mod[1])
  if name then
    name = name:gsub('%.git$', ''):match('[^/]+$')
  end
  M[name or modname] = mod
end

-- Discover plugin files and directories in this_dir
local function import_plugins()
  for name, type_ in vim.fs.dir(this_dir, { depth = 1 }) do
    if type_ == 'file' and name:match('%.lua$') and name ~= 'init.lua' then
      plug(vim.fs.joinpath(this_dir, name))
    elseif type_ == 'directory' then
      local init = vim.fs.joinpath(this_dir, name, 'init.lua')
      if vim.uv.fs_stat(init) then
        plug(vim.fs.joinpath(this_dir, name))
      end
    end
  end
end

import_plugins()

return M
