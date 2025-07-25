local M = {}

---@alias GitStatus { ignored: table<string, boolean>, tracked: table<string, boolean> }
---@alias GitStatusCache table<string, GitStatus>

---@param proc { wait: fun(): { code: integer, stdout: string } }
---@return table<string, boolean>
local parse_output = function(proc)
  local result = proc:wait()
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
      local opts = { cwd = path, text = true }
      local ignored_cmd = { 'git', 'ls-files', '--ignored', '--exclude-standard', '--others', '--directory' }
      local tracked_cmd = { 'git', 'ls-tree', 'HEAD', '--name-only' }
      ---@type GitStatus
      local status = {
        ignored = parse_output(vim.system(ignored_cmd, opts)),
        tracked = parse_output(vim.system(tracked_cmd, opts)),
      }

      rawset(self, path, status)
      return status
    end,
  })
end

-- local ignored_output = function(path)
--   local git_status = M.new()
--   local status = git_status[path]
--   if not status then
--     return {}
--   end
--   return status.ignored
-- end
-- print(ignored_output(vim.fn.getcwd()))
--
return M
