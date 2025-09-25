_G.t = { vim.uv.hrtime() }
vim.g.transparent = true
vim.g.loaded_netrw = false
-- vim.g.loaded_netrwPlugin = 1
vim.g.health = { style = 'float' }
-- for _, provider in ipairs({ 'node', 'perl', 'ruby' }) do
--   vim.g[provider] = 0 -- disable to silence warnings
-- end

vim.cmd([[runtime vimrc]])

--- Same as require but handles errors gracefully
---
--- @param module string
--- @param errexit? boolean
--- @return any?
_G.xprequire = function(module, errexit)
  local ok, mod = xpcall(require, debug.traceback, module)
  if not ok then
    if errexit ~= false then
      local msg = ('Error loading module %s:\n%s'):format(module, mod)
      vim.schedule(function()
        if errexit == true then
          error(msg)
        else
          vim.notify(msg, vim.log.levels.ERROR)
        end
      end)
    end
    return nil
  end
  return mod
end

_G.track = require('nvim.util.chrono')

vim.loader.enable()
vim.o.cmdheight = 0
vim.o.winborder = 'rounded'
track('xprequire extui', xprequire('vim._extui').enable({}))
-- xprequire('munchies')
track('xprequire nvim', xprequire('nvim'))
-- xprequire('nvim')
