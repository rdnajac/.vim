-- Copyright (c) 2020-2021 shadmansaleh
-- MIT license, see LICENSE for more details.
local M = {}

M.sep = package.config:sub(1, 1)
local luv = vim.uv or vim.loop

-- Figures out full path of lualine installation
local source = debug.getinfo(1, 'S').source
if source:sub(1, 1) == '@' then
  local base_start = source:find(table.concat({ 'lualine.nvim', 'lua', 'lualine_require.lua' }, M.sep))
  if base_start then
    source = source:sub(2, base_start + #'lualine.nvim/lua')
    if source then
      M.plugin_dir = source
    end
  end
end

--- checks if name is valid
---@param name string
---@return boolean
function M.is_valid_filename(name)
  local invalid_chars = '[^a-zA-Z0-9_. -]'
  return name:find(invalid_chars) == nil
end

---require module module
---@param module string module_name
---@return any the required module
function M.require(module)
  if not package or not package.loaded then
    -- Something wrong with execution environment. Maybe plugin manager cleared it.
    -- Just let regular require handle. We'll use the cache next time.
    return require(module)
  end
  if package.loaded[module] then
    return package.loaded[module]
  end
  local pattern_dir = module:gsub('%.', M.sep)
  local pattern_path = pattern_dir .. '.lua'
  if M.plugin_dir then
    local path = M.plugin_dir .. pattern_path
    assert(M.is_valid_filename(module), 'Invalid filename')
    local file_stat, dir_stat
    file_stat = luv.fs_stat(path)
    if not file_stat then
      path = M.plugin_dir .. pattern_dir
      dir_stat = luv.fs_stat(path)
      if dir_stat and dir_stat.type == 'directory' then
        path = path .. M.sep .. 'init.lua'
        file_stat = luv.fs_stat(path)
      end
    end
    if file_stat and file_stat.type == 'file' then
      local mod_result = dofile(path)
      package.loaded[module] = mod_result
      return mod_result
    end
  end

  pattern_path = table.concat({ 'lua/', module:gsub('%.', '/'), '.lua' })
  local paths = vim.api.nvim_get_runtime_file(pattern_path, true)
  if #paths <= 0 then
    pattern_path = table.concat({ 'lua/', module:gsub('%.', '/'), '/init.lua' })
    paths = vim.api.nvim_get_runtime_file(pattern_path, true)
  end
  if #paths > 0 then
    -- put entries from user config path in front
    local user_config_path = vim.fn.stdpath('config')
    table.sort(paths, function(a, b)
      local pattern = table.concat({ user_config_path, M.sep })
      return string.match(a, pattern) or not string.match(b, pattern)
    end)
    local mod_result = dofile(paths[1])
    package.loaded[module] = mod_result
    return mod_result
  end

  return require(module)
end

---requires modules when they are used
---@param modules table k-v table where v is module path and k is name that will
---                     be indexed
---@return table metatable where when a key is indexed it gets required and cached
function M.lazy_require(modules)
  return setmetatable({}, {
    __index = function(self, key)
      local loaded = rawget(self, key)
      if loaded ~= nil then
        return loaded
      end
      local module_location = modules[key]
      if module_location == nil then
        return nil
      end
      local module = M.require(module_location)
      rawset(self, key, module)
      return module
    end,
  })
end

return M
