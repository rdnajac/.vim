local command = vim.api.nvim_create_user_command

command('GitBlameLine', function()
  local line_number = vim.fn.line('.')
  local filename = vim.api.nvim_buf_get_name(0)
  print(vim.system({ 'git', 'blame', '-L', line_number .. ',+1', filename }):wait().stdout)
end, { desc = 'Print the git blame for the current line' })

local plug = require('nvim.plug')

command('PlugClean', plug.clean, { force = true })
command('Plug', function(args)
  if #args.fargs == 0 then
    print(vim.inspect(vim.pack.get()))
  else
    vim.pack.add({ 'https://github.com/' .. args.fargs[1] })
  end
end, { nargs = '?', force = true })

-- must pass nil to update all plugins with a bang
command('PlugUpdate', function(opts)
  vim.pack.update(nil, { force = opts.bang })
end, { bang = true, force = true })

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

command('Scratch', function(opts)
  if opts.bang == true then
    Snacks.scratch.select()
  else
    Snacks.scratch()
  end
end, {
  bang = true,
})
