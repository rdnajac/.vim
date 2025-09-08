-- user/repo can contain only letters, digits, '_', '-' and '.'
-- `%w`  represents all alphanumeric characters.
local user_repo_regex = '^[%w._-]+/[%w._-]+$'
local test = function()
  local cases = {
    'user/repo',
    'user_123/repo-1.0',
    'http://github.com/user/repo.git',
    'user/repo/extra',
    '/repo',
    'user/',
    'user!repo',
  }

  for _, case in ipairs(cases) do
    local ok = case:match(user_repo_regex) ~= nil
    print('[' .. (ok == true and 'PASS' or 'FAIL') .. '] ' .. case)
  end
end
-- test()
