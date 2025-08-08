local modname = require('meta').modname

local function set_reg_and_notify(text)
  vim.fn.setreg('*', text)
  Snacks.notify('yanked: ' .. text)
end

--- Yank Lua module name or require('modname') to system clipboard
---@param with_require boolean? If true, wrap in require(...)
local function yank_modname(with_require)
  local module = modname(vim.fn.expand('%:p'))
  if modname == '' then
    return
  end

  local text = with_require and ("lua require('" .. module .. "')") or modname
  set_reg_and_notify(text)
end

local function yank_func()
  local module = modname(vim.fn.expand('%:p'))
  if modname == '' then
    return
  end

  local text = "lua require('" .. module .. "')." .. vim.fn.expand('<cword>') .. '()'
  set_reg_and_notify(text)
end

-- stylua: ignore start
vim.keymap.set('n', 'ym', function() yank_modname(false) end, { buffer = true, desc = 'yank lua module name' })
vim.keymap.set('n', 'yM', function() yank_modname(true) end, { buffer = true, desc = 'yank require(...) form' })
vim.keymap.set('n', 'yr', function() yank_func() end, { buffer = true, desc = 'yank require + function' })
