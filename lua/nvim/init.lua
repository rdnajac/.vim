local function bookmark(key, module)
  vim.cmd(([[nnoremap <Bslash>%s <Cmd>call edit#luamod('%s')<CR>]]):format(key, module))
end

bookmark('n', 'nvim/init')
bookmark('p', 'nvim/plugins')
bookmark('u', 'nvim/util/init')
bookmark('P', 'nvim/util/plug')

local plugins = require('nvim.plugins')

local M = setmetatable({}, {
  __newindex = function(self, k, v) -- assignment: `self[k] = v`
    -- pin to a keymap for quick access
    bookmark(k:sub(1, 1), 'nvim/' .. k)
    -- lazy load submodules one more level deeper
    setmetatable(v, {
      __index = function(t, subk)
        local mod = require('nvim.' .. k .. '.' .. subk)
        rawset(t, subk, mod)
        return mod
      end,
    })
    -- set the module to the table
    rawset(self, k, v)
    -- add plugins to the list
    vim.list_extend(plugins, v.specs)
  end,
  __index = function(t, k) -- access: `table[key]`
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

-- PERF: filter plugins before converting to `vim.pack.Spec`
_G.Plugins = vim.tbl_filter(function(t)
  return t.enabled ~= false
  -- return t.enabled == true end,
end, plugins)

return M
