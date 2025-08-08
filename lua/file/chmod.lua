local function chmod(perm, path)
  path = path or vim.fn.expand('%')
  local mode = vim.fn.getfperm(path)

  if perm == '+x' then
    mode = mode:gsub('(..).', '%1x')
  elseif perm == '-x' then
    mode = mode:gsub('(..).', '%1-')
  elseif perm:match('^%d%d%d$') then
    local map = {
      ['0'] = '---',
      ['1'] = '--x',
      ['2'] = '-w-',
      ['3'] = '-wx',
      ['4'] = 'r--',
      ['5'] = 'r-x',
      ['6'] = 'rw-',
      ['7'] = 'rwx',
    }
    mode = perm:gsub('.', map)
  else
    vim.notify('Invalid permission: ' .. perm, vim.log.levels.ERROR)
    return
  end

  vim.fn.setfperm(path, mode)
  Snacks.notify('Changed permissions of ' .. path .. ' to ' .. mode)
end

return chmod
