-- override defaults
-- vim.notify = nv.notify
-- vim.print = dd
vim.o.cmdheight = 0 -- XXX: experimental!
-- BUG: ui2 error on declining to install
-- vim.schedule callback: ...dn/.neovim/share/nvim/runtime/lua/vim/_extui/cmdline.lua:140: Invalid window id: 1002
-- stack traceback:
-- 	[C]: in function 'nvim_win_set_config'
-- 	~/.neovim/share/nvim/runtime/lua/vim/_extui/cmdline.lua:140: in function ''
-- 	vim/_editor.lua: in function <vim/_editor.lua:0>
require('vim._extui').enable({})

-- see `vim._defer_require`
local _submodules = {
  blink = true,
  fs = true,
  keys = true,
  lsp = true,
  treesitter = true,
}

--- bookmark a submodule for quick access
--- @param key string the key to use (after <Bslash>)
--- @param module string the module as if it were `require`d
local function bookmark(key, module)
  return vim.keymap.set(
    'n',
    '<Bslash>' .. key,
    function() vim.fn['edit#luamod'](module) end,
    { desc = 'Edit ' .. module }
  )
end

bookmark('n', 'nvim/init')
bookmark('p', 'plugins')
bookmark('P', 'nvim/util/plug')
for k, _ in pairs(_submodules) do
  bookmark(k:sub(1, 1), 'nvim/' .. k)
end

--- works as a `createfn` for defaulttable or the __index metamethod
---@return table the module under `nvim/` or `nvim/util/`
local _index = function(k)
  return _submodules[k] and require('nvim.' .. k) or require('nvim.util')[k]
end

return vim.defaulttable(_index)
-- return setmetatable({}, {
--   __index = function(t, k)
--     local mod = _index(k)
--     rawset(t, k, mod)
--     return mod
--   end,
-- })
