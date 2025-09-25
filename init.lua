vim.g.t = { vim.uv.hrtime() }
vim.g.transparent = true
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.health = { style = 'float' }
for _, provider in ipairs({ 'node', 'perl', 'ruby' }) do
  vim.g[provider] = 0 -- disable to silence warnings
end

vim.cmd([[runtime vimrc]])
vim.loader.enable()

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

xprequire('nvim')

print(('nvim initialized in %.2f ms'):format((vim.uv.hrtime() - vim.g.t[1]) / 1e6))
-- TODO: get the time to `VimEnter` event
