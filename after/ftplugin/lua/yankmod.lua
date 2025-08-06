--- Yank Lua module name or require('modname') to system clipboard
---@param with_require boolean? If true, wrap in require(...)
local function yank_modname(with_require)
  local modname = require('meta').modname(vim.fn.expand('%:p'))
  if modname == '' then
    return
  end

  local text = with_require and ("lua require('" .. modname .. "')") or modname
  vim.fn.setreg('*', text)
  Snacks.notify('yanked lua module ' .. (with_require and '' or 'name: ') .. text)
end

-- stylua: ignore start
vim.keymap.set('n', 'ym', function() yank_modname(false) end, { buffer = true, desc = 'yank lua module name' })
vim.keymap.set('n', 'yM', function() yank_modname(true) end, { buffer = true, desc = 'yank require(...) form' })
