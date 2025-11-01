local M = {}

local modname = function(path)
  local name = vim.fn.fnamemodify(path, ':r:s?^.*/lua/??')
  return name:sub(-4) == 'init' and name:sub(1, -6) or name
end

local formats = {
  module = function(module)
    return module
  end,
  require = function(module)
    return "require('" .. module .. "')"
  end,
  lua_require = function(module, func)
    return "lua require('" .. module .. "')." .. func .. '()'
  end,
  print_require = function(module, func)
    return "=require('" .. module .. "')." .. func .. '()'
  end,
}

local function _yank(format_fn, ...)
  local module = modname(vim.fn.expand('%:p'))
  if module == '' then
    return
  end
  local text = format_fn(module, ...)
  vim.fn.setreg('*', text)
  print('yanked: ' .. text)
end

M.name = function()
  _yank(formats.module)
end

M.require = function()
  _yank(formats.require)
end

M.func = function()
  _yank(formats.lua_require, vim.fn.expand('<cword>'))
end

M.print = function()
  _yank(formats.print_require, vim.fn.expand('<cword>'))
end

return M
