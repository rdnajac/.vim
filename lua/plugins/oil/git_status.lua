local M = {}

---@alias GitStatus { ignored: table<string, boolean>, tracked: table<string, boolean> }
---@alias GitStatusCache table<string, GitStatus>

---@param path string
---@param cmd string[]
---@return table<string, boolean>
local function get_files(path, cmd)
  local result = vim.system(cmd, { cwd = path, text = true }):wait()
  local ret = {}
  if result.code == 0 then
    for line in vim.gsplit(result.stdout, '\n', { plain = true, trimempty = true }) do
      line = line:gsub('/$', '')
      ret[line] = true
    end
  end
  return ret
end

---@return GitStatusCache
function M.new()
  return setmetatable({}, {
    __index = function(self, path)
      ---@type GitStatus
      local status = {
        ignored = get_files(path, { 'git', 'ls-files', '--ignored', '--exclude-standard', '--others', '--directory' }),
        tracked = get_files(path, { 'git', 'ls-tree', 'HEAD', '--name-only' }),
      }

      rawset(self, path, status)
      return status
    end,
  })
end

return M
