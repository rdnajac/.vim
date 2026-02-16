local bookmarks = {
  n = 'init',
  b = 'blink',
  k = 'keys',
  l = 'lsp',
  t = 'treesitter',
  p = 'plugins',
  u = 'util',
  P = 'plug',
}

for k, v in pairs(bookmarks) do
  vim.cmd(([[nnoremap <Bslash>%s <Cmd>call edit#luamod('nvim/%s')<CR>]]):format(k, v))
end

local M = {
  blink = require('nvim.blink'),
  keys = require('nvim.keys'),
  lsp = require('nvim.lsp'),
  treesitter = require('nvim.treesitter'),
}

setmetatable(M, {
  __index = function(t, k) -- access: `table[key]`
    -- fall back to util for all other keys
    local mod = require('nvim.util')[k]
    rawset(t, k, mod)
    return mod
  end,
})

return M
