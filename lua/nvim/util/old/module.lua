local M = {}

local function includeexpr(module)
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

local mod_timer = assert(vim.uv.new_timer())
local mod_cb = {} ---@type table<string, fun(modname:string)[]>

---@return boolean waiting
local function mod_check()
  for modname, cbs in pairs(mod_cb) do
    if package.loaded[modname] then
      mod_cb[modname] = nil
      for _, cb in ipairs(cbs) do
        cb(modname)
      end
    end
  end
  return next(mod_cb) ~= nil
end

--- Call a function when a module is loaded.
--- The callback is called immediately if the module is already loaded.
--- Otherwise, it is called when the module is loaded.
---@param modname string
---@param cb fun(modname:string)
function M.on_module(modname, cb)
  mod_cb[modname] = mod_cb[modname] or {}
  table.insert(mod_cb[modname], cb)
  if mod_check() then
    mod_timer:start(
      100,
      100,
      vim.schedule_wrap(function()
        return not mod_check() and mod_timer:stop()
      end)
    )
  end
end

--- from shared.lua
--- @generic T
--- @param root string
--- @param mod T
--- @return T
function _defer_require(root, mod)
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

return M
