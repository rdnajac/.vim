local tracked_cmd = { 'git', 'ls-tree', 'HEAD', '--name-only' }
local ignored_cmd =
  { 'git', 'ls-files', '--ignored', '--exclude-standard', '--others', '--directory' }

---@param path string
---@param cmd string[]
---@return table<string, boolean>
local function get_files(path, cmd)
  local result = vim.system(cmd, { cwd = path, text = true }):wait()
  local ret = {}
  if result.code == 0 then
    for line in vim.gsplit(result.stdout, '\n', { plain = true, trimempty = true }) do
      ret[line:gsub('/$', '')] = true
    end
  end
  return ret
end

-- build git status cache
local function status()
  return setmetatable({}, {
    __index = function(self, key)
      local ret = {
        ignored = get_files(key, ignored_cmd),
        tracked = get_files(key, tracked_cmd),
      }
      rawset(self, key, ret)
      return ret
    end,
  })
end

return status
