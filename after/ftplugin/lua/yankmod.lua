local modname = function(path)
  local name = vim.fn.fnamemodify(path, ':r:s?^.*/lua/??')
  if name:sub(-5) == 'init' then
    name = name:sub(1, -6)
  end
  return name
end

local function set_reg_and_notify(text)
  vim.fn.setreg('*', text)
  Snacks.notify('yanked: ' .. text)
end

-- Wraps your yanking actions with module resolution
local function with_module(action)
  local module = modname(vim.fn.expand('%:p'))
  if module == '' then
    return
  end
  action(module)
end

local function yank_module_name()
  with_module(function(module)
    set_reg_and_notify(module)
  end)
end

local function yank_module_require()
  with_module(function(module)
    set_reg_and_notify("require('" .. module .. "')")
  end)
end

local function yank_func()
  with_module(function(module)
    set_reg_and_notify("lua require('" .. module .. "')." .. vim.fn.expand('<cword>') .. '()')
  end)
end

local function print_yank_func()
  with_module(function(module)
    set_reg_and_notify("=require('" .. module .. "')." .. vim.fn.expand('<cword>') .. '()')
  end)
end

vim.keymap.set('n', 'ym', yank_module_name, { buffer = true, desc = 'yank lua module name' })
vim.keymap.set('n', 'yM', yank_module_require, { buffer = true, desc = 'yank require(...) form' })
vim.keymap.set('n', 'yr', yank_func, { buffer = true, desc = 'yank require + function' })
vim.keymap.set('n', 'yR', print_yank_func, { buffer = true, desc = 'print require + function' })
