local M = {}

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

-- build git status cache using vim.defaulttable
M.status = function()
  return vim.defaulttable(function(path)
    return {
      ignored = get_files(path, ignored_cmd),
      tracked = get_files(path, tracked_cmd),
    }
  end)
end

M.test = function(path)
  return M.status()[path or vim.uv.cwd()]
end

-- print(vim.inspect(M.test(vim.fn.expand('~/.vim/lua/plug'))))

return setmetatable(M, {
  __call = function()
    return M.status()
  end,
})
