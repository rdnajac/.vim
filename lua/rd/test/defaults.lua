-- function to check the vim default value using vim systerm and calling bvim to set the value like `set shortmess&` and capture that output
local function get_vim_default(option)
  vim.system('vim -u NONE -c "set ' .. option .. '&" -c "echo &"' .. option .. '" -c "q!"', {
    stdout = true,
    stderr = true,
  }, function(result)
    if result.code == 0 then
      local value = result.stdout:match('%S+')
      print(option .. ' default value: ' .. value)
    else
      print('Error getting default value for ' .. option .. ': ' .. result.stderr)
    end
  end)
end
