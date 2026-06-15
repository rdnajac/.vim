return setmetatable({}, {
  __index = function(t, k)
    local modname = 'nvim.ui.' .. k
    local ok, m = xpcall(require, debug.traceback, modname)
    if ok then
      t[k] = m
      return m
    end
    error(([[`require('%s')` failed: %s]]):format(modname, m))
  end,
})
