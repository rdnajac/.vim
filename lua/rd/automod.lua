local fn = vim.fn
return function(topmod)
  return vim
    .iter(fn.readdir(fn.stdpath('config') .. '/lua/' .. topmod))
    :map(function(s) return fn.fnamemodify(s, ':r') end)
    :map(function(mname) return mname, require('nvim.' .. mname) end)
    :fold({}, rawset) -- inits an empty table and maps `t[k] = v`
  -- local _, mod = xpcall(require, debug.traceback, 'nvim.' .. modname)
end
