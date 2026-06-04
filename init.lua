vim.o.exrc = true
vim.loader.enable()
vim.cmd.run('vimrc')
_G.dd = Snacks.debug
_G.bt = dd.backtrace
_G.nv = setmetatable({ require('nvim.util') }, {
  __index = function(t, k)
    local modname = 'nvim.' .. k
    local ok, m = xpcall(require, debug.traceback, modname)
    if ok then
      t[k] = m
      return m
    end
    error(([[`require('%s')` failed: %s]]):format(modname, m))
  end,
})
vim.schedule(nv.ui.setup)
