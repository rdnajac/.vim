local M = {}

local function cd_and_echo(dir)
  if dir and dir ~= '' then
    vim.cmd('cd ' .. vim.fn.fnameescape(dir))
  end
  vim.cmd('pwd')
end

function M.prompt()
  local path = vim.fn.expand('%:p') or ''
  local git_root = Snacks.git.get_root() or ''
  local home = vim.loop.os_homedir() or ''
  local default

  if git_root ~= '' and path:find(git_root, 1, true) == 1 then
    default = path:sub(#git_root + 2)
  elseif home ~= '' and path:find(home, 1, true) == 1 then
    default = path:sub(#home + 2)
  else
    default = path
  end

  vim.ui.input({ prompt = 'Change Directory: ', default = default }, function(input)
    if input and input ~= '' then
      cd_and_echo(input)
    end
  end)
end

function M.smart()
  local cwd = vim.fn.getcwd()
  local file_dir = vim.fn.expand('%:p:h')
  local target = file_dir

  if file_dir == cwd then
    local root = Snacks.git.get_root()
    if root and root ~= '' then
      target = root
    end
  end

  cd_and_echo(target)
end

return M
