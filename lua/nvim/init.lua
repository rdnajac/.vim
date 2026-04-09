--- `require`s as all modules under `nvim/` directory
local fn = vim.fn

return vim
  .iter(fn.readdir(fn.fnamemodify(debug.getinfo(1).short_src, ':p:h')))
  :filter(function(name) return name ~= 'init.lua' end)
  :map(function(modname)
    modname = fn.fnamemodify(modname, ':r')
    local ok, mod = xpcall(require, debug.traceback, 'nvim.' .. modname)
    if not ok then
      vim.schedule(function()
        local fmt = 'Error `require()`ing: %s:\n%s'
        vim.notify((fmt):format(modname, mod), vim.log.levels.ERROR)
      end)
    end
    return modname, mod
  end)
  :fold({}, rawset)
