---@class lazydev.Config.mod: lazydev.Config
local M = {}

M.libs = {} ---@type lazydev.Library[]
M.words = {} ---@type table<string, string[]>
M.mods = {} ---@type table<string, string[]>
M.files = {} ---@type table<string, string[]>

---@param root string
---@return boolean
function M.is_enabled(root)
  local enabled = require('nvim.lsp.lazydev').enabled
  if type(enabled) == 'function' then
    return enabled(root) and true or false
  end
  return enabled
end

M.lua_root = true

---@type lazydev.Config
local library = require('nvim.lsp.lazydev').library

for _, lib in pairs(library) do
  table.insert(M.libs, {
    path = type(lib) == 'table' and lib.path or lib,
    words = type(lib) == 'table' and lib.words or {},
    mods = type(lib) == 'table' and lib.mods or {},
    files = type(lib) == 'table' and lib.files or {},
  })
end

for _, lib in ipairs(M.libs) do
  for _, word in ipairs(lib.words) do
    M.words[word] = M.words[word] or {}
    table.insert(M.words[word], lib.path)
  end

  for _, mod in ipairs(lib.mods) do
    M.mods[mod] = M.mods[mod] or {}
    table.insert(M.mods[mod], lib.path)
  end

  for _, file in ipairs(lib.files) do
    M.files[file] = M.files[file] or {}
    table.insert(M.files[file], lib.path)
  end
end

return M
