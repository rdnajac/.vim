-- local me = debug.getinfo(1, 'S').source:sub(2)
-- local dir = vim.fn.fnamemodify(me, ':p:h')
-- local files = vim.fn.globpath(dir, '*', false, true)

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
  keys = true,
  lsp = true,
  treesitter = true,
}

--- works as a `createfn` for defaulttable or the __index metamethod
---@param k key
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
