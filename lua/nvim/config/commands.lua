dd()
local command = vim.api.nvim_create_user_command

local function to_camel_case(str)
  return str
    :gsub('_%a', function(c)
      return c:sub(2):upper()
    end)
    :gsub('^%l', string.upper)
end

-- dynamically create vim commands for each picker
for name, picker in pairs(Snacks.picker) do
  if type(picker) == 'function' then
    local cmd = to_camel_case(name)
    if vim.fn.exists(':' .. cmd) ~= 2 then
      command(cmd, function(opts)
        picker()
      end, {
        desc = 'Snacks Picker: ' .. cmd,
      })
    end
  end
end
