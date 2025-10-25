--- Common utilities for standalone Lua execution
--- Provides vim API mocking and path setup

local M = {}

--- Setup package path for require() to work correctly
function M.setup_path()
  -- Add current directory and parent directories to path
  local cwd = io.popen('pwd'):read('*l')
  if cwd and cwd:find('/lua/') then
    local lua_dir = cwd:match('(.*)/lua') .. '/lua/'
    if not package.path:find(lua_dir, 1, true) then
      package.path = package.path .. ';' .. lua_dir .. '?.lua'
    end
  end
end

--- Mock vim API for standalone execution
function M.mock_vim()
  if vim then
    return -- Already in Neovim, no need to mock
  end

  -- Create global vim table
  _G.vim = {}

  -- Mock vim.loop (libuv bindings)
  local socket = require('socket')
  vim.loop = {
    hrtime = function()
      return socket.gettime() * 1e9 -- Convert to nanoseconds
    end,
  }

  -- Mock vim.tbl_extend
  vim.tbl_extend = function(behavior, ...)
    local result = {}
    for _, tbl in ipairs({ ... }) do
      for k, v in pairs(tbl) do
        if behavior == 'force' or result[k] == nil then
          result[k] = v
        end
      end
    end
    return result
  end

  -- Mock vim.deepcopy
  vim.deepcopy = function(tbl)
    if type(tbl) ~= 'table' then
      return tbl
    end
    local result = {}
    for k, v in pairs(tbl) do
      result[k] = vim.deepcopy(v)
    end
    return result
  end

  -- Mock vim.json with proper encoding
  vim.json = {
    encode = function(val, indent_level)
      indent_level = indent_level or 0

      if type(val) == 'string' then
        return '"' .. val:gsub('"', '\\"') .. '"'
      elseif type(val) == 'number' then
        return tostring(val)
      elseif type(val) == 'boolean' then
        return tostring(val)
      elseif type(val) == 'nil' then
        return 'null'
      elseif type(val) == 'table' then
        -- Check if it's an array
        local is_array = true
        local max_index = 0
        for k, _ in pairs(val) do
          if type(k) ~= 'number' or k < 1 or k ~= math.floor(k) then
            is_array = false
            break
          end
          max_index = math.max(max_index, k)
        end

        if is_array and max_index > 0 then
          local items = {}
          for i = 1, max_index do
            table.insert(items, vim.json.encode(val[i], indent_level + 1))
          end
          return '[' .. table.concat(items, ', ') .. ']'
        else
          local items = {}
          for k, v in pairs(val) do
            local key = type(k) == 'string' and ('"' .. k .. '"') or tostring(k)
            table.insert(items, key .. ': ' .. vim.json.encode(v, indent_level + 1))
          end
          return '{' .. table.concat(items, ', ') .. '}'
        end
      else
        return '"' .. tostring(val) .. '"'
      end
    end,
  }
end

--- Initialize environment for standalone execution
function M.init()
  M.setup_path()
  M.mock_vim()
end

return M
