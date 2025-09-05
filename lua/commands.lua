local command = vim.api.nvim_create_user_command

-- `Snacks` Ex functions
command('Scratch', function(opts)
  if opts.bang == true then
    Snacks.scratch.select()
  else
    Snacks.scratch()
  end
end, { bang = true })

local function to_camel_case(str)
  return str
    :gsub('_%a', function(c)
      return c:sub(2):upper()
    end)
    :gsub('^%l', string.upper)
end

-- cache the original keys to skip
local skip = vim.tbl_keys(Snacks.picker)
skip[#skip + 1] = 'config' -- this one gets missed
skip[#skip + 1] = 'keymap'

-- also skip the lazy picker if we're not using lazy.nvim
if not package.loaded['lazy'] then
  skip[#skip + 1] = 'lazy'
end

-- HACK: force early loding of picker config
Snacks.picker.config.setup()

local pickers = vim.tbl_filter(function(name)
  return not vim.list_contains(skip, name)
end, vim.tbl_keys(Snacks.picker))

for _, name in ipairs(pickers) do
  local picker = Snacks.picker[name]
  local cmd = to_camel_case(name)
  if vim.fn.exists(':' .. cmd) ~= 2 then
    command(cmd, picker, { desc = 'Snacks Picker: ' .. cmd })
  end
end

vim.api.nvim_create_user_command('PlugClean', function()
  vim.pack.del(vim.tbl_map(
    function(plugin)
      return plugin.spec.name
    end,
    vim.tbl_filter(function(plugin)
      return plugin.active == false
    end, vim.pack.get())
  ))
end, { desc = 'Remove unused plugins' })

vim.api.nvim_create_user_command('Plug', function(args)
  if #args.fargs == 0 then
    print(vim.inspect(vim.pack.get()))
  else
    vim.pack.add({ 'https://github.com/' .. args.fargs[1] })
  end
end, { nargs = '?', desc = 'Add a plugin' })

-- must pass nil to update all plugins with a bang
vim.api.nvim_create_user_command('PlugUpdate', function(opts)
  vim.pack.update(nil, { force = opts.bang })
end, { bang = true })
