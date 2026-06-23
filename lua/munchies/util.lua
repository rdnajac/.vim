local M = {}

-- function to check the vim default value using vim system and calling vim to set the value like `set shortmess&` and capture that output
function M.get_vim_default(option)
  vim.system({
    'nvim',
    '-Nu',
    'NONE',
    '--headless',
    '-c',
    'set ' .. option .. '&',
    '-c',
    'put =&' .. option,
    '-c',
    '%print',
    '-c',
    'q!',
  }, { text = true }, function(result)
    if result.code == 0 and result.stdout ~= '' then
      local lines = vim.split(vim.trim(result.stdout), '\n')
      local value = lines[#lines]
      print(option .. ' default value: ' .. value)
    else
      print('Error getting default value for ' .. option .. ': ' .. (result.stderr ~= '' and result.stderr or 'unknown option?'))
    end
  end)
end

local index = { cmd = {}, abr = {} }
function M.command_abbrevations()
  for line in io.lines(vim.fn.expand('$VIMRUNTIME/doc/index.txt')) do
    local cmd, abr = line:match('^|:(%w+)|%s+:(%w+).*$')
    if cmd and abr then
      index.cmd[cmd] = abr
      index.abr[abr] = cmd
    end
  end
end


return M
