local M = vim.defaulttable(function(k)
  -- return require(vim.fs.basename(vim.fs.dirname(debug.getinfo(1, 'S').source:sub(2))) .. '.' .. k)
  return require('nvim.' .. k)
  -- TODO: handle utils
end)

-- TODO: move to ui
vim.o.cmdheight = 0
vim.o.winborder = 'rounded'
xprequire('vim._extui').enable({}) -- XXX: experimental

_G.nv = M

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

local skip = { init = true, icons = true, plug = true, util = true }
local dir = vim.fs.joinpath(vim.fn.stdpath("config"), "lua", "nvim")

for name, _ in vim.fs.dir(dir) do
  local mod = name:match("^([%w%-]+)")
  if mod and not skip[mod] then
    nv.plug(mod)
  end
end

nv.plug(require('nvim.plugin.folke')[1])

return M
