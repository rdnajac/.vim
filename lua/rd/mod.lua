local fn = vim.fn

local M = {}

M.automod = function(topmod)
  return vim
    .iter(fn.readdir(fn.stdpath('config') .. '/lua/' .. topmod))
    :map(function(s) return fn.fnamemodify(s, ':r') end)
    :map(function(mname) return mname, require('nvim.' .. mname) end)
    :fold({}, rawset) -- inits an empty table and maps `t[k] = v`
  -- local _, mod = xpcall(require, debug.traceback, 'nvim.' .. modname)
end

M.debug_require = function()
  -- override the default require function to log module loading
  local original_require = require
  require = function(modname)
    local msg = ('[require] ' .. modname)
    vim.notify(msg, vim.log.levels.INFO, {
      hide_from_history = true,
    })
    return original_require(modname)
  end

  setmetatable(package.loaded, {
    __index = function(t, mod)
      print('[first require] ' .. mod)
      local r = original_require(mod)
      rawset(t, mod, r)
      return r
    end,
  })

  require = function(mod) return original_require(mod) end
end

return M
