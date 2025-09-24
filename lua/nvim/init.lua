local M = vim.defaulttable(function(k)
  -- return require(vim.fs.basename(vim.fs.dirname(debug.getinfo(1, 'S').source:sub(2))) .. '.' .. k)
  return require('nvim.' .. k)
  -- TODO: handle utils
end)

-- set some ui options
vim.o.cmdheight = 0
-- vim.o.pumblend = 0 -- default: 10
-- vim.o.smoothscroll = true -- default: false
vim.o.winborder = 'rounded'
-- behavior changes with cmdheight and winborder
require('vim._extui').enable({}) -- XXX: experimental

M.did = vim.defaulttable()
M.lazyload = require('nvim.util.lazyload')
M.status = function()
  return string.format(
    '%s%s%s%s',
    nv.lsp.status(),
    nv.copilot.status(),
    nv.treesitter.status(),
    nv.diagnostic.status()
  )
end

_G.info = function(...) -- TODO: Snacks.debug
  vim.notify(vim.inspect(...), vim.log.levels.INFO)
end

return M
