return vim
  .iter(vim.fn.readdir(vim.fs.dirname(debug.getinfo(1).short_src)))
  :filter(function(name) return not vim.endswith(name, '.lua') end)
  :map(function(modname)
    local ok, mod = xpcall(require, debug.traceback, 'nvim.' .. modname)
    if ok and mod then
      return modname, mod
    end
    vim.schedule(function()
      local fmt = 'Error `require()`ing: %s:\n%s'
      vim.notify((fmt):format(modname, mod), vim.log.levels.ERROR)
    end)
  end)
  :fold(require('nvim.util'), rawset)
