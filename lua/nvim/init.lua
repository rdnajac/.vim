local function bookmark(key, module)
  vim.cmd(([[nnoremap <Bslash>%s <Cmd>call edit#luamod('%s')<CR>]]):format(key, module))
end

bookmark('n', 'nvim/init')
bookmark('p', 'nvim/plugins')
bookmark('u', 'nvim/util/init')
bookmark('P', 'nvim/util/plug')

local M = setmetatable({}, {
  __newindex = function(self, k, v) -- assignment: `self[k] = v`
    -- pin to a keymap for quick access
    bookmark(k:sub(1, 1), 'nvim/' .. k)
    -- setmetatable(v, {
    --   __index = function(t, subk)
    --     local mod = require(table.concat({ 'nvim', k, subk }, '.'))
    --     rawset(t, subk, mod)
    --     return mod
    --   end,
    -- })
    rawset(self, k, v)
  end,
  __index = function(t, k) -- access: `table[key]`
    -- fall back to util for all other keys
    local mod = require('nvim.util')[k]
    rawset(t, k, mod)
    return mod
  end,
})

M.blink = require('nvim.blink')
M.fs = require('nvim.fs')
M.keys = require('nvim.keys')
M.lsp = require('nvim.lsp')
M.treesitter = require('nvim.treesitter')

return M
