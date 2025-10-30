local M = {}

local _cmd = {
  ignored = { 'ls-files', '--ignored', '--exclude-standard', '--others', '--directory' },
  status = { '-c', 'status.relativePaths=true', 'status', '.', '--short' },
  tracked = { 'ls-tree', 'HEAD', '--name-only' },
  tracked_cwd = { 'ls-tree', 'HEAD', '.', '--name-only' },
}

M.short_codes = {
  ['?'] = 'Untracked',
  ['A'] = 'Added',
  ['M'] = 'Modified',
  ['D'] = 'Deleted',
  ['R'] = 'Renamed',
  ['C'] = 'Copied',
  ['U'] = 'Unmerged',
  ['T'] = 'TypeChanged',
  [' '] = 'Unmodified',
}

---@param cmd string[] git command args
---@param bufnr? integer
---@return string[]|{} stdout lines
M.Git = function(cmd, bufnr)
  local git_dir = vim.fn.FugitiveGitDir(bufnr)
  local res = vim.fn.FugitiveExecute(cmd, git_dir)
  if res.exit_status ~= 0 then
    Snacks.notify.warn(res.stderr)
    return {}
  end
  return res.stdout
end

---@param subcmd string
---@param quotepath? boolean
---@return string[] git args
M.cmd = function(subcmd, quotepath)
  local git_cmd_args = quotepath == false and { '-c', 'core.quotepath=false' } or {}
  return vim.list_extend(git_cmd_args, _cmd[subcmd])
end

---@return table buffer status info
M.status = function()
  local function get_files(bufnr_or_path, command)
    local r = M.Git(command, bufnr_or_path)
    local t = {}
    for _, line in ipairs(r) do
      t[line:gsub('/$', '')] = true
    end
    return t
  end

  return vim.defaulttable(function(bufnr_or_path)
    local status_cmd = M.cmd('status', false)
    local status_result = M.Git(status_cmd, bufnr_or_path)

    local files = {}
    for _, line in ipairs(status_result) do
      if line ~= '' then
        local index_status, work_status, filepath = line:sub(1, 1), line:sub(2, 2), line:sub(4)
        files[filepath] = {
          index = M.short_codes[index_status] or index_status,
          working = M.short_codes[work_status] or work_status,
          short = index_status .. work_status,
        }
      end
    end

    return {
      ignored = get_files(bufnr_or_path, M.cmd('ignored')),
      tracked = get_files(bufnr_or_path, M.cmd('tracked')),
      files = files,
    }
  end)
end

M.test = function()
  dd(M.status()[vim.uv.cwd()])
end

M.short_status = function()
  return M.Git(M.cmd('status', false))
end

return setmetatable(M, {
  __call = function(_, cmd, bufnr_or_path)
    return M.Git(cmd, bufnr_or_path)
  end,
})
