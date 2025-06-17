local M = {}

---@param dir string
local function cd_and_echo(dir)
  if dir and dir ~= '' then
    vim.cmd('cd ' .. vim.fn.fnameescape(dir))
  end
  vim.cmd('pwd')
end

function M.prompt_dir()
  vim.ui.input({ prompt = 'Change Directory: ', default = vim.fn.getcwd() }, function(input)
    cd_and_echo(input)
  end)
end

function M.smart_cd()
  local cwd = vim.fn.getcwd()
  local target = vim.fn.expand('%:p:h')

  if cwd == target then
    target = LazyVim.root.get()
  end

  cd_and_echo(target)
end

return M
