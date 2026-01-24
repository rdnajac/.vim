--- nvim.init
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
  mini = true,
  treesitter = true,
}

local __index = function(t, k)
  if _submodules[k] then
    -- lazy load runtime modules in the `nv` namespace
    local mod = require('nvim.' .. k)
    rawset(t, k, mod)
    return mod
  else
    -- expose all utils on the `nv` module
    local mod = require('nvim.util')[k]
    rawset(t, k, mod)
    return mod
  end
end

-- index = function(k)
-- return vim.defaulttable(function(k)

return setmetatable({}, {
  __index = __index,
})
